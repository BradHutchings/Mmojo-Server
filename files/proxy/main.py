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

    # proxy request to OpenAI API
    headers = {k: v for k, v in request.headers.items() if
               k not in {'host', 'content-length', 'x-forwarded-for', 'x-real-ip', 'connection'}}
    url = f'{proxied_hosts.get_matching(request.url.path)}{request.url.path}'

    start_dt = datetime.datetime.now()

    request_body = None
    try:
        request_body = await request.json() if request.method in {'POST', 'PUT'} else None
    except json.JSONDecodeError:
        raise HTTPException(status_code=400, detail='Invalid JSON body')

    # request_data
    this_request_id = 0
    if request.url.path.startswith("/v1/"):
        request_id = request_id + 1
        this_request_id = request_id
        print("Request ID: " + str(this_request_id))
        print("Request URL:" + request.url.path)

    request_data = {
        'id': this_request_id,
        'path': request.url.path,
        'request_body': request_body,
    }

    request_data_filename = f"{this_request_id:07d}"

    if this_request_id > 0:
        with open("requests/" + request_data_filename, "w") as file:
            file.write(json.dumps(request_data, indent=4))


    completion_string = ""

    async def stream_api_response():
        nonlocal this_request_id
        nonlocal request_data
        nonlocal request_data_filename
        nonlocal completion_string

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

                    if (request.url.path == "/v1/chat/completions"):
                        data_lines = chunk.decode('utf-8').splitlines()
                        for data in data_lines:
                            data_json = None
                            if data.startswith("data: "):
                                data = data[6:].strip()
                                if data.startswith("[DONE]"):
                                    # print("Completion:\n" + completion_string)
                                    pass
                                else:
                                    data_json = json.loads(data)

                            if data_json != None:
                                try:
                                    delta = data_json["choices"][0]["delta"]["content"]
                                    completion_string = completion_string + delta
                                    # print("completion_string:\n" + completion_string + "\n----------")
                                except Exception as e:
                                    pass

                            request_data["elapsed_ms"] = elapsed_ms
                            request_data["completion"] = completion_string

                            with open("requests/" + request_data_filename, "w") as file:
                                file.write(json.dumps(request_data, indent=4))

                    elif (request.url.path == "/v1/models"):
                        # with open("requests/" + request_data_filename, "w") as file:
                        #     file.write(json.dumps(request_data, indent=4))
                        pass

                    elif (request.url.path == "/v1/completions"):
                        # with open("requests/" + request_data_filename, "w") as file:
                        #    file.write(json.dumps(request_data, indent=4))
                        pass

                    elif (request.url.path == "/v1/responses"):
                        # with open("requests/" + request_data_filename, "w") as file:
                        #    file.write(json.dumps(request_data, indent=4))
                        pass

                    elif (request.url.path == "/v1/embeddings"):
                        # with open("requests/" + request_data_filename, "w") as file:
                        #    file.write(json.dumps(request_data, indent=4))
                        pass

                    else:
                        # with open("requests/" + request_data_filename, "w") as file:
                        #    file.write(json.dumps(request_data, indent=4))
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
