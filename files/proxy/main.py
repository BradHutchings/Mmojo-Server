#!/usr/bin/env python3

#-------------------------------------------------------------------------------
# Patch https://github.com/fangwentong/openai-proxy/blob/master/main.py
# We won't use the database for logging.
# We'll use "#######" files in a "requests" subdirectory.
# These request files can be read and navigated by the visualizer, written with
# tkinter.
#-------------------------------------------------------------------------------

import json
import time
import os
import glob
import datetime
from contextlib import asynccontextmanager

import httpx
from fastapi import FastAPI, Request, HTTPException
from starlette.background import BackgroundTask

from config import proxied_hosts_config
from log import OpenAILog, save_log, create_tables
from utils import PathMatchingTree, OverrideStreamResponse

proxied_hosts = PathMatchingTree(proxied_hosts_config)

client = httpx.AsyncClient()

# FastAPI app
app = FastAPI()

request_id = 0

# Clear our the "requests" subdirectory.
directory_path = "requests"
os.makedirs(directory_path, exist_ok=True)
files = glob.glob(os.path.join(directory_path, '*'))
for f in files:
    if os.path.isfile(f):
        try:
            os.remove(f)
            print(f"Removed file: {f}")
        except OSError as e:
            print(f"Error removing file {f}: {e}")
            pass

async def proxy_openai_api(request: Request):
    global request_id
    if request.url.path.startswith("/v1/"):
        request_id = request_id + 1
    response_string = ""

    if request.url.path.startswith("/v1/"):
        print("Noting URL:" + request.url.path)
        pass

    # proxy request to OpenAI API
    headers = {k: v for k, v in request.headers.items() if
               k not in {'host', 'content-length', 'x-forwarded-for', 'x-real-ip', 'connection'}}
    url = f'{proxied_hosts.get_matching(request.url.path)}{request.url.path}'

    start_dt = datetime.datetime.now()

    try:
        request_body = await request.json() if request.method in {'POST', 'PUT'} else None
    except json.JSONDecodeError:
        raise HTTPException(status_code=400, detail='Invalid JSON body')

    async def stream_api_response():
        global request_id
        nonlocal response_string

        try:
            st = client.stream(request.method, url, headers=headers, params=request.query_params, json=request_body)
            async with st as res:
                response.status_code = res.status_code
                response.init_headers({k: v for k, v in res.headers.items() if
                                       k not in {'content-length', 'content-encoding', 'alt-svc'}})

                content = bytearray()
                first_chunk = True

                async for chunk in res.aiter_bytes():
                    yield chunk
                    content.extend(chunk)

                    now_dt = datetime.datetime.now()
                    elapsed_ms = (now_dt - start_dt).microseconds // 1000
                    request_data_filename = f"{request_id:07d}"

                    if (request.url.path == "/v1/chat/completions"):
                        data_lines = chunk.decode('utf-8').splitlines()
                        for data in data_lines:
                            data_json = None
                            if data.startswith("data: "):
                                data = data[6:].strip()
                                if data.startswith("[DONE]"):
                                    # print("Response:\n" + response_string)
                                    pass
                                else:
                                    data_json = json.loads(data)

                            if data_json != None:
                                try:
                                    delta = data_json["choices"][0]["delta"]["content"]
                                    response_string = response_string + delta
                                    # print("response_string:\n" + response_string + "\n----------")
                                except Exception as e:
                                    pass

                            request_data = {
                                'id': request_id,
                                'elapsed_ms': elapsed_ms,
                                'path': request.url.path,
                                'request_body': request_body,
                                'response': response_string,
                            }

                            with open("requests/" + request_data_filename, "w") as file:
                                file.write(json.dumps(request_data, indent=4))

                    elif (request.url.path == "/v1/models"):
                        request_data = {
                            'id': request_id,
                            'elapsed_ms': elapsed_ms,
                            'path': request.url.path,
                            'request_body': request_body,
                        }

                        with open("requests/" + request_data_filename, "w") as file:
                            file.write(json.dumps(request_data, indent=4))
                        pass

                    elif (request.url.path == "/v1/completions"):
                        request_data = {
                            'id': request_id,
                            'elapsed_ms': elapsed_ms,
                            'path': request.url.path,
                            'request_body': request_body,
                        }

                        with open("requests/" + request_data_filename, "w") as file:
                            file.write(json.dumps(request_data, indent=4))
                        pass

                    elif (request.url.path == "/v1/responses"):
                        request_data = {
                            'id': request_id,
                            'elapsed_ms': elapsed_ms,
                            'path': request.url.path,
                            'request_body': request_body,
                        }

                        with open("requests/" + request_data_filename, "w") as file:
                            file.write(json.dumps(request_data, indent=4))
                        pass

                    elif (request.url.path == "/v1/embeddings"):
                        request_data = {
                            'id': request_id,
                            'elapsed_ms': elapsed_ms,
                            'path': request.url.path,
                            'request_body': request_body,
                        }

                        with open("requests/" + request_data_filename, "w") as file:
                            file.write(json.dumps(request_data, indent=4))
                        pass

                    else:
                        request_data = {
                            'id': request_id,
                            'elapsed_ms': elapsed_ms,
                            'path': request.url.path,
                            'request_body': request_body,
                        }

                        with open("requests/" + request_data_filename, "w") as file:
                            file.write(json.dumps(request_data, indent=4))
                        pass


        except httpx.RequestError as exc:
            raise HTTPException(status_code=500, detail=f'An error occurred while requesting: {exc}')

    response = OverrideStreamResponse(stream_api_response())

    return response


@app.route('/{path:path}', methods=['GET', 'POST', 'PUT', 'DELETE'])
async def request_handler(request: Request):
    return await proxy_openai_api(request)


if __name__ == '__main__':
    import uvicorn

    uvicorn.run("main:app", host="127.0.0.1", port=8000, log_level="info", reload=True)
