window.addEventListener('message', function(event) {
    const data = event.data;
    if (!data || !data.action) return;

    switch (data.action) {
        case 'updateMatchState':
            console.log('[NUI] Match state:', data.state);
            break;
        case 'showNotification':
            showNotification(data.message, data.type);
            break;
        case 'hideAllOverlays':
            hideAllPanels();
            break;
        default:
            break;
    }
});

function hideAllPanels() {
    const panels = document.querySelectorAll('.ui-panel');
    panels.forEach(panel => {
        if (panel.id !== 'player-hud' && panel.id !== 'team-hud' && panel.id !== 'killfeed-container' && panel.id !== 'chat-container') {
            panel.classList.add('hidden');
        }
    });
    if (typeof ChatUI !== 'undefined' && ChatUI.toggleInput) {
        ChatUI.toggleInput(false);
    }
}

function showNotification(msg, type) {
    const container = document.getElementById('notification-container');
    if (!container) return;

    const toast = document.createElement('div');
    toast.className = `toast toast-${type || 'info'}`;
    toast.innerText = msg;

    container.appendChild(toast);
    setTimeout(() => {
        toast.remove();
    }, 3500);
}

function sendNuiCallback(eventName, data, cb) {
    fetch(`https://${GetParentResourceName()}/${eventName}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify(data || {})
    }).then(resp => resp.json()).then(respData => {
        if (cb) cb(respData);
    }).catch(err => {
        if (cb) cb({ error: err });
    });
}
