const ChatUI = {
    isOpen: false,
    inactivityTimer: null,

    init() {
        const sendBtn = document.getElementById('btn-send-chat');
        const inputField = document.getElementById('chat-input-field');

        if (sendBtn) {
            sendBtn.addEventListener('click', () => this.submit());
        }

        if (inputField) {
            inputField.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    this.submit();
                } else if (e.key === 'Escape') {
                    this.toggleInput(false);
                }
            });
        }

        // Start initial inactivity timer
        this.resetInactivityTimer();
    },

    resetInactivityTimer() {
        const container = document.getElementById('chat-container');
        if (!container) return;

        // Unhide chat UI when active or new message arrives
        container.classList.remove('auto-hidden');

        if (this.inactivityTimer) clearTimeout(this.inactivityTimer);

        // If chat input is open, keep it visible indefinitely
        if (this.isOpen) return;

        // Auto-hide after 5 seconds of inactivity
        this.inactivityTimer = setTimeout(() => {
            if (!this.isOpen) {
                container.classList.add('auto-hidden');
            }
        }, 5000);
    },

    toggleInput(show) {
        const container = document.getElementById('chat-container');
        const inputWrapper = document.getElementById('chat-input-wrapper');
        const inputField = document.getElementById('chat-input-field');

        this.isOpen = show;

        if (container) {
            container.classList.remove('auto-hidden');
        }

        if (inputWrapper) {
            if (show) {
                inputWrapper.classList.remove('hidden');
                if (inputField) {
                    inputField.focus();
                    inputField.value = '';
                }
                if (this.inactivityTimer) clearTimeout(this.inactivityTimer);
            } else {
                inputWrapper.classList.add('hidden');
                if (inputField) inputField.blur();
                sendNuiCallback('closeChatUI');
                this.resetInactivityTimer();
            }
        }
    },

    submit() {
        const inputField = document.getElementById('chat-input-field');
        if (!inputField) return;

        const text = inputField.value.trim();
        if (text.length > 0) {
            sendNuiCallback('submitChatMessage', { message: text });
        }

        this.toggleInput(false);
    },

    addMessage(data) {
        const box = document.getElementById('chat-messages-box');
        if (!box) return;

        const isSpecial = data.tag === 'ADMIN' || data.isAdmin;
        const isSystem = data.tag === 'SYSTEM';

        const rowClass = isSpecial ? 'chat-msg-row msg-special' :
                         (isSystem ? 'chat-msg-row msg-system' : 'chat-msg-row msg-player');

        const tagClass = isSpecial ? 'tag-admin' :
                         (isSystem ? 'tag-system' :
                         (data.tag === 'TEAM' ? 'tag-team' : 'tag-player'));

        const tagText = (data.tag || (data.isAdmin ? 'ADMIN' : 'PLAYER')).toUpperCase();

        const row = document.createElement('div');
        row.className = rowClass;

        row.innerHTML = `
            <span class="chat-tag ${tagClass}">[${tagText}]</span>
            <span class="chat-author">${data.author || 'Player'}:</span>
            <span class="chat-text">${data.message}</span>
        `;

        box.appendChild(row);
        box.scrollTop = box.scrollHeight;

        // Reset inactivity timer when a new message arrives so players can read it
        this.resetInactivityTimer();
    }
};

document.addEventListener('DOMContentLoaded', () => ChatUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'toggleChatInput') {
        ChatUI.toggleInput(event.data.show !== undefined ? event.data.show : true);
    } else if (event.data.action === 'addChatMessage') {
        ChatUI.addMessage(event.data);
    }
});

// Keydown listener for 'T' key to open chat input (Standard GTA/FiveM behavior)
window.addEventListener('keydown', (e) => {
    if (e.key === 't' || e.key === 'T') {
        // Only open chat if not currently typing in another input
        if (document.activeElement.tagName !== 'INPUT' && document.activeElement.tagName !== 'TEXTAREA') {
            e.preventDefault();
            ChatUI.toggleInput(true);
        }
    }
});
