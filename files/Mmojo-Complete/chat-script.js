/*
    From https://github.com/aaronbolton/simple-ui
    - Aaron Bolton's simple-ui
    - MIT license mentioned in README.md, but no LICENSE.md file.
*/

console.log('script.js loaded successfully');

const kMmojoServerApiUrl = '/v1';

class ChatUI {
    constructor() {
        this.messages = [];
        this.isLoading = false;
        this.metrics = {
            timePerOutputToken: 0,
            requestsRunning: 0,
            requestsWaiting: 0,
            cacheUsage: 0
        };
        this.settings = {
            apiUrl: kMmojoServerApiUrl,
            apiKey: '',
            modelName: 'gpt-3.5-turbo',
            systemPrompt: 'You are a helpful assistant.',
            useServerProxy: false,
            darkMode: true // Default to light mode
        };
        
        // Rate limiting
        this.lastRequestTime = 0;
        this.minRequestInterval = 1000; // 1 second minimum between requests
        
        // Debug mode flag
        this.debugMode = true; // Temporarily enabled for debugging token usage
        
        this.initializeElements();
        this.bindEvents(); // Bind events immediately
        this.autoResizeTextarea();
        this.init(); // Call async init method for settings loading
    }
    
    // Debug logging helper
    debug(...args) {
        if (this.debugMode) {
            console.log('[ChatUI Debug]:', ...args);
        }
    }
    
    async init() {
        await this.loadSettings(); // Await settings loading
        this.initializeTheme();
        this.validateSettings(); // Validate settings after loading
        // Initialize performance display with only tok/s
        this.updatePerformanceDisplay(null, 0);
    }
    
    initializeElements() {
        this.messagesContainer = document.getElementById('messages');
        this.messageInput = document.getElementById('messageInput');
        this.sendButton = document.getElementById('sendButton');
        this.charCount = document.getElementById('charCount');
        this.status = document.getElementById('status');
        this.settingsPanel = document.getElementById('settingsPanel');
        this.settingsToggle = document.getElementById('settingsToggle');
        this.themeToggle = document.getElementById('themeToggle');
        
        // Settings inputs
        this.apiUrlInput = document.getElementById('apiUrl');
        this.apiKeyInput = document.getElementById('apiKey');
        this.modelNameInput = document.getElementById('modelName');
        this.systemPromptInput = document.getElementById('systemPrompt');
        this.saveSettingsButton = document.getElementById('saveSettings');
        this.resetSettingsButton = document.getElementById('resetSettings');
        this.clearChatButton = document.getElementById('clearChat');
    }
    
    bindEvents() {
        this.debug('Binding events...');
        this.debug('Elements found:', {
            sendButton: !!this.sendButton,
            messageInput: !!this.messageInput,
            settingsToggle: !!this.settingsToggle,
            themeToggle: !!this.themeToggle
        });
        
        // Main chat events
        if (this.sendButton) {
            this.sendButton.addEventListener('click', () => {
                this.debug('Send button clicked');
                this.sendMessage();
            });
        }
        
        if (this.messageInput) {
            this.messageInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    this.debug('Enter key pressed');
                    this.sendMessage();
                }
            });
            this.messageInput.addEventListener('input', () => this.updateCharCount());
        }
        
        // Settings events
        if (this.settingsToggle) {
            this.settingsToggle.addEventListener('click', () => this.toggleSettings());
        }
        if (this.themeToggle) {
            this.themeToggle.addEventListener('click', () => this.toggleTheme());
        }
        if (this.saveSettingsButton) {
            this.saveSettingsButton.addEventListener('click', () => this.saveSettings());
        }
        if (this.resetSettingsButton) {
            this.resetSettingsButton.addEventListener('click', () => this.resetSettings());
        }
        if (this.clearChatButton) {
            this.clearChatButton.addEventListener('click', () => this.clearChat());
        }
        
        // Close settings when clicking outside
        document.addEventListener('click', (e) => {
            if (this.settingsPanel && !this.settingsPanel.contains(e.target) && 
                this.settingsToggle && !this.settingsToggle.contains(e.target) && 
                this.settingsPanel.classList.contains('open')) {
                this.toggleSettings();
            }
        });
        
        this.debug('Events bound successfully');
    }
    
    autoResizeTextarea() {
        this.messageInput.addEventListener('input', () => {
            this.messageInput.style.height = 'auto';
            this.messageInput.style.height = Math.min(this.messageInput.scrollHeight, 120) + 'px';
        });
    }
    
    updateCharCount() {
        const count = this.messageInput.value.length;
        this.charCount.textContent = `${count}/4000`;
        this.charCount.style.color = count > 3800 ? '#f56565' : '#a0aec0';
    }
    
    updateStatus(message, type = 'ready') {
        this.status.textContent = message;
        this.status.className = `status ${type}`;
    }
    
    toggleSettings() {
        this.settingsPanel.classList.toggle('open');
        if (this.settingsPanel.classList.contains('open')) {
            this.loadSettingsToUI();
        }
    }
    
    async loadSettings() {
        // First load server configuration from .env
        try {
            const response = await fetch('/api/config');
            if (response.ok) {
                const serverConfig = await response.json();
                this.settings.apiUrl = serverConfig.apiUrl;
                this.settings.modelName = serverConfig.modelName;
                
                // If server has API key configured, we'll use server proxy
                if (serverConfig.hasApiKey) {
                    this.settings.useServerProxy = true;
                    this.settings.apiKey = 'server-configured'; // Placeholder
                }
            }
        } catch (error) {
            console.log('Could not load server config, using client-side settings');
        }
        
        // Then override with any saved local settings
        const saved = localStorage.getItem('chatui_settings');
        if (saved) {
            const localSettings = JSON.parse(saved);
            // Don't override server settings unless explicitly set by user
            if (localSettings.apiUrl && localSettings.apiUrl !== kMmojoServerApiUrl) {
                this.settings.apiUrl = localSettings.apiUrl;
            }
            if (localSettings.modelName && localSettings.modelName !== 'gpt-3.5-turbo') {
                this.settings.modelName = localSettings.modelName;
            }
            if (localSettings.apiKey && localSettings.apiKey !== '') {
                this.settings.apiKey = localSettings.apiKey;
                this.settings.useServerProxy = false; // Use client-side if user provided key
            }
            if (localSettings.systemPrompt) {
                this.settings.systemPrompt = localSettings.systemPrompt;
            }
            if (typeof localSettings.darkMode === 'boolean') {
                this.settings.darkMode = localSettings.darkMode;
            }
        }
        
        this.validateSettings();
    }
    
    loadSettingsToUI() {
        this.apiUrlInput.value = this.settings.apiUrl;
        this.modelNameInput.value = this.settings.modelName;
        this.systemPromptInput.value = this.settings.systemPrompt;
        
        if (this.settings.useServerProxy) {
            this.apiKeyInput.value = '';
            this.apiKeyInput.placeholder = 'Using server configuration';
            this.apiKeyInput.disabled = true;
        } else {
            this.apiKeyInput.value = this.settings.apiKey;
            this.apiKeyInput.placeholder = 'Enter your API key';
            this.apiKeyInput.disabled = false;
        }
    }
    
    saveSettings() {
        // Validate and sanitize inputs
        const apiUrl = this.apiUrlInput.value.trim() || kMmojoServerApiUrl;
        const modelName = this.modelNameInput.value.trim() || 'gpt-3.5-turbo';
        const systemPrompt = this.systemPromptInput.value.trim() || 'You are a helpful assistant.';
        
        // Validate API URL format
        try {
            new URL(apiUrl);
        } catch (error) {
            this.updateStatus('Invalid API URL format', 'error');
            return;
        }
        
        // Validate model name (basic check)
        if (!/^[a-zA-Z0-9._/-]+$/.test(modelName)) {
            this.updateStatus('Invalid model name format', 'error');
            return;
        }
        
        // Validate system prompt length
        if (systemPrompt.length > 2000) {
            this.updateStatus('System prompt too long (max 2000 characters)', 'error');
            return;
        }
        
        this.settings.apiUrl = apiUrl;
        this.settings.modelName = modelName;
        this.settings.systemPrompt = systemPrompt;
        
        // Only update API key if not using server proxy
        if (!this.settings.useServerProxy) {
            this.settings.apiKey = this.apiKeyInput.value.trim();
        }
        
        // If user provides API key, switch to client-side mode
        if (this.apiKeyInput.value.trim() && !this.apiKeyInput.disabled) {
            this.settings.apiKey = this.apiKeyInput.value.trim();
            this.settings.useServerProxy = false;
        }
        
        localStorage.setItem('chatui_settings', JSON.stringify(this.settings));
        this.validateSettings();
        this.updateStatus('Settings saved!', 'ready');
        
        setTimeout(() => {
            this.toggleSettings();
        }, 1000);
    }
    
    async resetSettings() {
        if (!confirm('Reset all settings to defaults from .env file? This will clear your saved API key and other customizations.')) {
            return;
        }
        
        try {
            // Get defaults from server .env configuration
            const response = await fetch('/api/defaults');
            if (response.ok) {
                const defaults = await response.json();
                
                // Reset settings to defaults
                this.settings.apiUrl = defaults.apiUrl;
                this.settings.modelName = defaults.modelName;
                this.settings.systemPrompt = defaults.systemPrompt;
                
                // Reset API key and server proxy settings
                if (defaults.hasApiKey) {
                    this.settings.useServerProxy = true;
                    this.settings.apiKey = 'server-configured';
                } else {
                    this.settings.useServerProxy = false;
                    this.settings.apiKey = '';
                }
                
                // Don't reset theme preference - keep user's preference
                // this.settings.darkMode = false;
                
                // Clear localStorage to remove any saved overrides
                localStorage.removeItem('chatui_settings');
                
                // Update UI immediately
                this.loadSettingsToUI();
                this.validateSettings();
                
                this.updateStatus('Settings reset to defaults!', 'ready');
                
                setTimeout(() => {
                    if (this.settingsPanel.classList.contains('open')) {
                        this.toggleSettings();
                    }
                }, 1500);
            } else {
                throw new Error('Could not load defaults from server');
            }
        } catch (error) {
            console.error('Error resetting settings:', error);
            this.updateStatus('Error resetting settings', 'error');
        }
    }
    
    initializeTheme() {
        this.applyTheme();
    }
    
    toggleTheme() {
        this.settings.darkMode = !this.settings.darkMode;
        this.applyTheme();
        localStorage.setItem('chatui_settings', JSON.stringify(this.settings));
    }
    
    applyTheme() {
        const body = document.body;
        const sunIcon = this.themeToggle.querySelector('.sun-icon');
        const moonIcon = this.themeToggle.querySelector('.moon-icon');
        
        if (this.settings.darkMode) {
            body.classList.add('dark-mode');
            sunIcon.style.display = 'none';
            moonIcon.style.display = 'block';
        } else {
            body.classList.remove('dark-mode');
            sunIcon.style.display = 'block';
            moonIcon.style.display = 'none';
        }
    }
    
    validateSettings() {
        if (this.settings.useServerProxy) {
            this.updateStatus('Ready (using server config)', 'ready');
        } else if (!this.settings.apiKey || this.settings.apiKey === 'server-configured') {
            this.updateStatus('Please configure API key in settings', 'error');
        } else {
            this.updateStatus('Ready', 'ready');
        }
    }
    
    clearChat() {
        this.messages = [];
        this.messagesContainer.innerHTML = `
            <div class="message system">
                <div class="message-content">
                    Chat cleared. Start a new conversation!
                </div>
            </div>
        `;
        
        // Reset performance display to show only tok/s
        this.updatePerformanceDisplay(null, 0);
        
        this.updateStatus('Chat cleared', 'ready');
    }
    
    async resendMessage(message) {
        if (this.isLoading) {
            this.updateStatus('Please wait for current message to complete', 'error');
            return;
        }
        
        if (!this.settings.useServerProxy && (!this.settings.apiKey || this.settings.apiKey === 'server-configured')) {
            this.updateStatus('Please configure API key in settings', 'error');
            return;
        }
        
        // Add user message again
        this.addMessage('user', message);
        
        // Show loading
        this.isLoading = true;
        this.sendButton.disabled = true;
        this.updateStatus('Thinking...', 'loading');
        
        // Add streaming message container
        const streamingMessageId = this.addStreamingMessage();
        
        try {
            const startTime = Date.now();
            let totalTokens = 0;
            
            const response = await this.callAPIStreaming(message, (chunk, isComplete) => {
                if (!isComplete) {
                    this.updateStreamingMessage(streamingMessageId, chunk);
                    totalTokens++;
                }
            });
            
            const endTime = Date.now();
            const responseTime = (endTime - startTime) / 1000;
            
            // Collect metrics for performance data only
            const metrics = await this.collectMetrics();
            
            // Calculate tokens per second using chunk count
            const tokensPerSecond = totalTokens > 0 ? Math.round(totalTokens / responseTime) : 0;
            
            // Finalize the streaming message with only tok/s
            this.finalizeStreamingMessage(streamingMessageId, metrics, tokensPerSecond);
            
            this.updateStatus('Ready', 'ready');
            
        } catch (error) {
            console.error('Error resending message:', error);
            
            this.removeStreamingMessage(streamingMessageId);
            this.addMessage('system', `Error: ${error.message}`);
            this.updateStatus('Error occurred', 'error');
        } finally {
            this.isLoading = false;
            this.sendButton.disabled = false;
        }
    }
    
    async sendMessage() {
        this.debug('sendMessage called');
        const message = this.messageInput.value.trim();
        this.debug('Message content:', message);
        this.debug('Is loading:', this.isLoading);
        
        // Enhanced validation
        if (!message || this.isLoading) {
            this.debug('Early return: no message or already loading');
            return;
        }
        
        // Rate limiting check
        const now = Date.now();
        if (now - this.lastRequestTime < this.minRequestInterval) {
            this.updateStatus('Please wait before sending another message', 'error');
            return;
        }
        this.lastRequestTime = now;
        
        // Validate message length
        if (message.length > 4000) {
            this.updateStatus('Message too long (max 4000 characters)', 'error');
            return;
        }
        
        if (!this.settings.useServerProxy && (!this.settings.apiKey || this.settings.apiKey === 'server-configured')) {
            this.debug('API key not configured');
            this.updateStatus('Please configure API key in settings', 'error');
            return;
        }
        
        this.debug('Proceeding with message send...');
        
        // Add user message
        this.addMessage('user', message);
        this.messageInput.value = '';
        this.updateCharCount();
        this.messageInput.style.height = 'auto';
        
        // Show loading
        this.isLoading = true;
        this.sendButton.disabled = true;
        this.updateStatus('Thinking...', 'loading');
        
        // Add streaming message container
        const streamingMessageId = this.addStreamingMessage();
        
        try {
            const startTime = Date.now();
            let totalTokens = 0;
            
            const response = await this.callAPIStreaming(message, (chunk, isComplete) => {
                if (!isComplete) {
                    this.updateStreamingMessage(streamingMessageId, chunk);
                    totalTokens++;
                }
            });
            
            const endTime = Date.now();
            const responseTime = (endTime - startTime) / 1000;
            
            // Collect metrics for performance data only
            const metrics = await this.collectMetrics();
            
            // Calculate tokens per second using chunk count
            const tokensPerSecond = totalTokens > 0 ? Math.round(totalTokens / responseTime) : 0;
            
            // Finalize the streaming message with only tok/s
            this.finalizeStreamingMessage(streamingMessageId, metrics, tokensPerSecond);
            
            this.updateStatus(this.settings.useServerProxy ? 'Ready (using server config)' : 'Ready', 'ready');
        } catch (error) {
            console.error('API Error:', error);
            this.removeStreamingMessage(streamingMessageId);
            
            // Better error message formatting
            let errorMessage = 'Error: ';
            if (error.message.includes('fetch')) {
                errorMessage += 'Unable to connect to API server. Please check your connection.';
            } else if (error.message.includes('401')) {
                errorMessage += 'Invalid API key. Please check your settings.';
            } else if (error.message.includes('429')) {
                errorMessage += 'Rate limit exceeded. Please try again later.';
            } else if (error.message.includes('500')) {
                errorMessage += 'Server error. Please try again later.';
            } else {
                errorMessage += error.message || 'Unknown error occurred';
            }
            
            this.addMessage('system', errorMessage);
            this.updateStatus('Error occurred', 'error');
        } finally {
            this.isLoading = false;
            this.sendButton.disabled = false;
        }
    }
    
    async callAPI(userMessage) {
        const messages = [
            { role: 'system', content: this.settings.systemPrompt },
            ...this.messages.filter(m => m.role !== 'system').slice(-10), // Keep last 10 messages
            { role: 'user', content: userMessage }
        ];
        
        // Use server proxy if configured, otherwise direct API call
        if (this.settings.useServerProxy) {
            const response = await fetch('/api/chat', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    messages: messages,
                    model: this.settings.modelName,
                    max_tokens: 1000,
                    temperature: 0.7
                })
            });
            
            if (!response.ok) {
                const errorData = await response.json().catch(() => ({}));
                throw new Error(errorData.error?.message || `HTTP ${response.status}: ${response.statusText}`);
            }
            
            const data = await response.json();
            const content = data.choices[0]?.message?.content || 'No response received';
            
            return { content };
        } else {
            // Direct API call
            const apiUrl = this.settings.apiUrl.endsWith('/') 
                ? this.settings.apiUrl + 'chat/completions'
                : this.settings.apiUrl + '/chat/completions';
            
            const response = await fetch(apiUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.settings.apiKey}`
                },
                body: JSON.stringify({
                    model: this.settings.modelName,
                    messages: messages,
                    max_tokens: 1000,
                    temperature: 0.7
                })
            });
            
            if (!response.ok) {
                const errorData = await response.json().catch(() => ({}));
                throw new Error(errorData.error?.message || `HTTP ${response.status}: ${response.statusText}`);
            }
            
            const data = await response.json();
            const content = data.choices[0]?.message?.content || 'No response received';
            
            return { content };
        }
    }
    
    async callAPIStreaming(userMessage, onChunk) {
        const messages = [
            { role: 'system', content: this.settings.systemPrompt },
            ...this.messages.filter(m => m.role !== 'system').slice(-10), // Keep last 10 messages
            { role: 'user', content: userMessage }
        ];
        
        // Create abort controller for timeout
        const controller = new AbortController();
        const timeoutId = setTimeout(() => {
            controller.abort();
        }, 120000); // 2 minute timeout
        
        try {
            // Use server proxy if configured, otherwise direct API call
            if (this.settings.useServerProxy) {
                const response = await fetch('/api/chat', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        messages: messages,
                        model: this.settings.modelName,
                        max_tokens: 1000,
                        temperature: 0.7,
                        stream: true
                    }),
                    signal: controller.signal
                });
                
                if (!response.ok) {
                    const errorData = await response.text().catch(() => '');
                    throw new Error(errorData || `HTTP ${response.status}: ${response.statusText}`);
                }
                
                return this.processStreamResponse(response, onChunk);
            } else {
                // Direct API call with streaming
                const apiUrl = this.settings.apiUrl.endsWith('/') 
                    ? this.settings.apiUrl + 'chat/completions'
                    : this.settings.apiUrl + '/chat/completions';
                
                const response = await fetch(apiUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${this.settings.apiKey}`
                    },
                    body: JSON.stringify({
                        model: this.settings.modelName,
                        messages: messages,
                        max_tokens: 1000,
                        temperature: 0.7,
                        stream: true
                    }),
                    signal: controller.signal
                });
                
                if (!response.ok) {
                    const errorData = await response.json().catch(() => ({}));
                    throw new Error(errorData.error?.message || `HTTP ${response.status}: ${response.statusText}`);
                }
                
                return this.processStreamResponse(response, onChunk);
            }
        } catch (error) {
            if (error.name === 'AbortError') {
                throw new Error('Request timed out. Please try again.');
            }
            throw error;
        } finally {
            clearTimeout(timeoutId);
        }
    }
    
    async processStreamResponse(response, onChunk) {
        const reader = response.body.getReader();
        const decoder = new TextDecoder();
        let buffer = '';
        
        try {
            while (true) {
                const { done, value } = await reader.read();
                
                if (done) break;
                
                buffer += decoder.decode(value, { stream: true });
                const lines = buffer.split('\n');
                buffer = lines.pop(); // Keep the incomplete line in buffer
                
                for (const line of lines) {
                    const trimmedLine = line.trim();
                    if (trimmedLine === '' || trimmedLine === 'data: [DONE]') continue;
                    
                    if (trimmedLine.startsWith('data: ')) {
                        try {
                            const jsonData = trimmedLine.slice(6); // Remove 'data: ' prefix
                            const parsed = JSON.parse(jsonData);
                            
                            if (parsed.choices && parsed.choices[0]) {
                                const choice = parsed.choices[0];
                                if (choice.delta && choice.delta.content) {
                                    onChunk(choice.delta.content, false);
                                }
                            }
                        } catch (e) {
                            console.warn('Failed to parse streaming chunk:', trimmedLine);
                        }
                    }
                }
            }
            
            // Call onChunk one final time to indicate completion
            onChunk('', true);
            
            return {};
        } catch (error) {
            throw new Error(`Streaming error: ${error.message}`);
        }
    }
    
    addMessage(role, content, metrics = null, tokensPerSecond = 0) {
        const message = { role, content, timestamp: new Date(), metrics, tokensPerSecond };
        this.messages.push(message);
        
        const messageElement = document.createElement('div');
        messageElement.className = `message ${role}`;
        
        // Render content based on role
        let messageContentHtml = '';
        if (role === 'assistant') {
            // Parse and separate think content from response for assistant messages
            const parsed = this.parseThinkAndResponse(content);
            
            // Create think boxes HTML
            let thinkBoxesHtml = '';
            if (parsed.thinkContents.length > 0) {
                parsed.thinkContents.forEach((thinkContent, index) => {
                    const thinkId = `msg-${Date.now()}-think-${index}`;
                    thinkBoxesHtml += `
                        <div class="think-box">
                            <div class="think-header" onclick="toggleThinkBox('${thinkId}')">
                                <div class="think-label">
                                    <svg class="think-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <path d="M9 18l6-6-6-6"/>
                                    </svg>
                                    💭 Thinking...
                                </div>
                            </div>
                            <div class="think-content expanded" id="${thinkId}">
                                <div class="think-content-inner">${this.escapeHtml(thinkContent).replace(/\n/g, '<br>')}</div>
                            </div>
                        </div>
                    `;
                });
            }
            
            // Render the response content as markdown
            const renderedResponse = this.renderMarkdown(parsed.response);
            
            // Only show tok/s for assistant messages
            let speedHtml = '';
            if (tokensPerSecond > 0) {
                speedHtml = `
                    <div class="message-token-usage">
                        ${tokensPerSecond} tok/s
                    </div>
                `;
            }
            
            messageContentHtml = `
                ${thinkBoxesHtml ? `<div class="message-think-boxes" style="display: block;">${thinkBoxesHtml}</div>` : ''}
                <div class="message-content">${renderedResponse}</div>
                ${speedHtml}
            `;
        } else {
            // For user and system messages, escape HTML
            messageContentHtml = `<div class="message-content">${this.escapeHtml(content)}</div>`;
        }
        
        // Add resend button for user messages
        let resendButtonHtml = '';
        if (role === 'user') {
            resendButtonHtml = `
                <div class="message-actions">
                    <button class="resend-button" data-message="${this.escapeHtmlAttribute(content)}" title="Resend message">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/>
                            <path d="M21 3v5h-5"/>
                            <path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"/>
                            <path d="M3 21v-5h5"/>
                        </svg>
                    </button>
                </div>
            `;
        }
        
        messageElement.innerHTML = `
            ${messageContentHtml}
            ${resendButtonHtml}
        `;
        
        // Add event listener for resend button if it's a user message
        if (role === 'user') {
            const resendButton = messageElement.querySelector('.resend-button');
            if (resendButton) {
                resendButton.addEventListener('click', () => {
                    this.resendMessage(content);
                });
            }
        }
        
        this.messagesContainer.appendChild(messageElement);
        this.scrollToBottom();
    }
    
    addStreamingMessage() {
        const messageId = 'streaming-' + Date.now();
        const messageElement = document.createElement('div');
        messageElement.className = 'message assistant streaming';
        messageElement.id = messageId;
        messageElement.innerHTML = `
            <div class="message-think-boxes" id="${messageId}-think"></div>
            <div class="message-content">
                <span class="streaming-text"></span>
                <span class="streaming-cursor">|</span>
            </div>
        `;
        
        this.messagesContainer.appendChild(messageElement);
        this.scrollToBottom();
        
        return messageId;
    }
    
    updateStreamingMessage(messageId, chunk) {
        const messageElement = document.getElementById(messageId);
        if (messageElement) {
            const textElement = messageElement.querySelector('.streaming-text');
            const thinkContainer = document.getElementById(`${messageId}-think`);
            
            if (textElement && thinkContainer) {
                // Parse the chunk to separate think content from response content
                const currentFullText = textElement.textContent + chunk;
                const parsed = this.parseThinkAndResponse(currentFullText);
                
                // Update think boxes
                if (parsed.thinkContents.length > 0) {
                    thinkContainer.innerHTML = '';
                    parsed.thinkContents.forEach((thinkContent, index) => {
                        const thinkId = `${messageId}-think-${index}`;
                        const thinkBox = this.createThinkBox(thinkId, thinkContent);
                        thinkContainer.appendChild(thinkBox);
                    });
                    thinkContainer.style.display = 'block';
                } else {
                    thinkContainer.style.display = 'none';
                }
                
                // Update response content (without think tags)
                textElement.textContent = parsed.response;
                
                this.scrollToBottom();
            }
        }
    }
    
    parseThinkAndResponse(text) {
        const thinkContents = [];
        let response = text;
        
        // Find all complete think tag pairs
        const thinkRegex = /<think>([\s\S]*?)<\/think>/gi;
        let match;
        
        while ((match = thinkRegex.exec(text)) !== null) {
            thinkContents.push(match[1].trim());
        }
        
        // Remove all think tags from response
        response = text.replace(thinkRegex, '').trim();
        
        this.debug('parseThinkAndResponse:', {
            originalText: text.substring(0, 100) + '...',
            thinkContentsFound: thinkContents.length,
            response: response.substring(0, 100) + '...'
        });
        
        return {
            thinkContents,
            response
        };
    }
    
    createThinkBox(thinkId, content) {
        const thinkBox = document.createElement('div');
        thinkBox.className = 'think-box';
        thinkBox.innerHTML = `
            <div class="think-header" onclick="toggleThinkBox('${thinkId}')">
                <div class="think-label">
                    <svg class="think-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M9 18l6-6-6-6"/>
                    </svg>
                    💭 Thinking...
                </div>
            </div>
            <div class="think-content expanded" id="${thinkId}">
                <div class="think-content-inner">${this.escapeHtml(content).replace(/\n/g, '<br>')}</div>
            </div>
        `;
        return thinkBox;
    }
    
    async collectMetrics() {
        try {
            let metricsUrl;
            
            // Use server proxy if available
            if (this.settings.useServerProxy) {
                metricsUrl = '/api/metrics';
            } else {
                // Extract the base URL from the API URL
                const baseUrl = this.settings.apiUrl.replace('/v1', '').replace(/\/+$/, '');
                metricsUrl = `${baseUrl}/metrics`;
            }
            
            const response = await fetch(metricsUrl);
            if (!response.ok) {
                console.warn('Could not fetch metrics:', response.statusText);
                return null;
            }
            
            const metricsText = await response.text();
            return this.parsePrometheusMetrics(metricsText);
        } catch (error) {
            console.warn('Error collecting metrics:', error);
            return null;
        }
    }
    
    parsePrometheusMetrics(metricsText) {
        const metrics = {
            timePerOutputToken: 0,
            requestsRunning: 0,
            requestsWaiting: 0,
            cacheUsage: 0
        };
        
        const lines = metricsText.split('\n');
        
        for (const line of lines) {
            // Parse time per output token (calculate average from histogram)
            if (line.includes('vllm:time_per_output_token_seconds_sum')) {
                const sumMatch = line.match(/vllm:time_per_output_token_seconds_sum.*?\s+([\d.]+)/);
                if (sumMatch) {
                    const sum = parseFloat(sumMatch[1]);
                    
                    // Find the corresponding count
                    const countLine = lines.find(l => l.includes('vllm:time_per_output_token_seconds_count'));
                    if (countLine) {
                        const countMatch = countLine.match(/vllm:time_per_output_token_seconds_count.*?\s+([\d.]+)/);
                        if (countMatch) {
                            const count = parseFloat(countMatch[1]);
                            if (count > 0) {
                                metrics.timePerOutputToken = Math.round((sum / count) * 1000); // Convert to ms
                            }
                        }
                    }
                }
            }
            
            // Parse running requests
            else if (line.includes('vllm:num_requests_running') && !line.includes('#')) {
                const match = line.match(/vllm:num_requests_running.*?\s+([\d.]+)/);
                if (match) {
                    metrics.requestsRunning = parseInt(parseFloat(match[1]));
                }
            }
            
            // Parse waiting requests
            else if (line.includes('vllm:num_requests_waiting') && !line.includes('#')) {
                const match = line.match(/vllm:num_requests_waiting.*?\s+([\d.]+)/);
                if (match) {
                    metrics.requestsWaiting = parseInt(parseFloat(match[1]));
                }
            }
            
            // Parse cache usage (prefer the non-deprecated version)
            else if (line.includes('vllm:kv_cache_usage_perc') && !line.includes('#') && !line.includes('gpu_cache_usage_perc')) {
                const match = line.match(/vllm:kv_cache_usage_perc.*?\s+([\d.]+)/);
                if (match) {
                    metrics.cacheUsage = Math.round(parseFloat(match[1]) * 100); // Convert to percentage
                }
            }
            // Fallback to deprecated version if new one not found
            else if (line.includes('vllm:gpu_cache_usage_perc') && !line.includes('#') && metrics.cacheUsage === 0) {
                const match = line.match(/vllm:gpu_cache_usage_perc.*?\s+([\d.]+)/);
                if (match) {
                    metrics.cacheUsage = Math.round(parseFloat(match[1]) * 100); // Convert to percentage
                }
            }
        }
        
        return metrics;
    }
    
    updatePerformanceDisplay(metrics, tokensPerSecond = 0) {
        const performanceElement = document.getElementById('performanceDisplay');
        if (performanceElement) {
            // Only show tok/s
            const speed = tokensPerSecond > 0 ? tokensPerSecond : 'null';
            performanceElement.textContent = `${speed} tok/s`;
            performanceElement.style.display = 'block';
        }
    }
    
    scrollToBottom() {
        this.messagesContainer.scrollTop = this.messagesContainer.scrollHeight;
    }
    
    finalizeStreamingMessage(messageId, metrics, tokensPerSecond) {
        console.log('🎯 finalizeStreamingMessage called with tokensPerSecond:', tokensPerSecond);
        this.debug('finalizeStreamingMessage called with tokensPerSecond:', tokensPerSecond);
        const messageElement = document.getElementById(messageId);
        if (messageElement) {
            const textElement = messageElement.querySelector('.streaming-text');
            const cursor = messageElement.querySelector('.streaming-cursor');
            const thinkContainer = messageElement.querySelector('.message-think-boxes');
            
            if (textElement && cursor) {
                // Remove streaming cursor
                cursor.remove();
                
                // Get the final content and parse it
                const fullContent = textElement.textContent;
                const parsed = this.parseThinkAndResponse(fullContent);
                
                // Update the message element to match the final format
                messageElement.className = 'message assistant';
                messageElement.id = '';
                
                // Render the response content as markdown
                const renderedResponse = this.renderMarkdown(parsed.response);
                
                // Update the message content (preserve existing think container)
                const messageContentDiv = messageElement.querySelector('.message-content');
                if (messageContentDiv) {
                    messageContentDiv.innerHTML = renderedResponse;
                }
                
                // Add tok/s display if available
                if (tokensPerSecond > 0) {
                    const speedDiv = document.createElement('div');
                    speedDiv.className = 'message-token-usage';
                    speedDiv.textContent = `${tokensPerSecond} tok/s`;
                    messageElement.appendChild(speedDiv);
                }
                
                // Ensure think container is visible if it has content
                if (thinkContainer && thinkContainer.children.length > 0) {
                    thinkContainer.style.display = 'block';
                }
                
                // Add the message to our messages array
                this.messages.push({
                    role: 'assistant',
                    content: fullContent,
                    timestamp: new Date(),
                    metrics,
                    tokensPerSecond
                });
                
                // Update performance display - only show tok/s
                this.updatePerformanceDisplay(metrics, tokensPerSecond);
            }
        }
    }
    
    removeStreamingMessage(messageId) {
        const messageElement = document.getElementById(messageId);
        if (messageElement) {
            messageElement.remove();
        }
    }
    
    renderMarkdown(text) {
        if (typeof marked !== 'undefined') {
            return marked.parse(text);
        } else {
            // Fallback if marked is not available
            return this.escapeHtml(text).replace(/\n/g, '<br>');
        }
    }
    
    escapeHtml(text) {
        if (typeof text !== 'string') {
            return String(text);
        }
        
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
    
    // Additional security helper for attribute values
    escapeHtmlAttribute(text) {
        if (typeof text !== 'string') {
            return String(text);
        }
        
        return text
            .replace(/&/g, '&amp;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#x27;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/\//g, '&#x2F;');
    }
    
    // Test function to create a sample think container
    testThinkContainer() {
        console.log('Creating test think container...');
        const testMessage = '<think>This is a test think content. Let me think about this problem step by step. First, I need to understand what the user is asking. Then I should consider the best approach.</think>This is the actual response that should be visible to the user.';
        this.addMessage('assistant', testMessage);
    }
}

// Global function to toggle think boxes
function toggleThinkBox(thinkId) {
    const thinkContent = document.getElementById(thinkId);
    const thinkHeader = thinkContent ? thinkContent.previousElementSibling : null;
    
    if (!thinkContent || !thinkHeader) {
        console.error('Think box elements not found:', { thinkContent: !!thinkContent, thinkHeader: !!thinkHeader });
        return;
    }
    
    if (thinkContent.classList.contains('expanded')) {
        // Currently expanded, collapse it
        thinkContent.classList.remove('expanded');
        thinkContent.classList.add('collapsed');
        thinkHeader.classList.add('collapsed');
    } else {
        // Currently collapsed (or default expanded), expand it
        thinkContent.classList.remove('collapsed');
        thinkContent.classList.add('expanded');
        thinkHeader.classList.remove('collapsed');
    }
}

// Test function to manually trigger send
console.log('script.js loaded successfully');

// Initialize the chat UI when the page loads
document.addEventListener('DOMContentLoaded', () => {
    console.log('DOM Content Loaded - Initializing ChatUI');
    window.chatUI = new ChatUI();
});
