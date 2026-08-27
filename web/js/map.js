const MapUI = {
    zoomLevel: 1.0,
    minZoom: 0.75,
    maxZoom: 2.5,
    isOpen: false,
    isDragging: false,
    startX: 0,
    startY: 0,
    translateX: 0,
    translateY: 0,

    init() {
        const btnClose = document.getElementById('btn-close-map');
        const btnIn = document.getElementById('btn-zoom-in');
        const btnOut = document.getElementById('btn-zoom-out');
        const viewport = document.getElementById('map-viewport');

        if (btnClose) btnClose.addEventListener('click', () => this.toggle(false));
        if (btnIn) btnIn.addEventListener('click', () => this.zoom(0.25));
        if (btnOut) btnOut.addEventListener('click', () => this.zoom(-0.25));

        if (viewport) {
            viewport.addEventListener('wheel', (e) => {
                e.preventDefault();
                const delta = e.deltaY < 0 ? 0.15 : -0.15;
                this.zoom(delta);
            });

            viewport.addEventListener('mousedown', (e) => {
                this.isDragging = true;
                this.startX = e.clientX - this.translateX;
                this.startY = e.clientY - this.translateY;
            });

            window.addEventListener('mousemove', (e) => {
                if (!this.isDragging) return;
                this.translateX = e.clientX - this.startX;
                this.translateY = e.clientY - this.startY;
                this.applyTransform();
            });

            window.addEventListener('mouseup', () => {
                this.isDragging = false;
            });
        }
    },

    zoom(delta) {
        this.zoomLevel = Math.min(this.maxZoom, Math.max(this.minZoom, this.zoomLevel + delta));
        const badge = document.getElementById('zoom-level-text');
        if (badge) {
            badge.innerText = `${Math.round(this.zoomLevel * 100)}%`;
        }
        this.applyTransform();
    },

    applyTransform() {
        const wrapper = document.getElementById('map-canvas-wrapper');
        if (wrapper) {
            wrapper.style.transform = `translate(${this.translateX}px, ${this.translateY}px) scale(${this.zoomLevel})`;
        }
    },

    toggle(show) {
        const container = document.getElementById('map-container');
        if (!container) return;

        this.isOpen = show !== undefined ? show : !this.isOpen;

        if (this.isOpen) {
            container.classList.remove('hidden');
        } else {
            container.classList.add('hidden');
            fetch(`https://${GetParentResourceName()}/closeMapUI`, { method: 'POST', body: JSON.stringify({}) }).catch(() => {});
        }
    }
};

document.addEventListener('DOMContentLoaded', () => MapUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'toggleMapUI') {
        MapUI.toggle(event.data.show);
    } else if (event.data.action === 'hideAllOverlays') {
        MapUI.toggle(false);
    }
});

// Key M handler to toggle map inside NUI
window.addEventListener('keydown', (e) => {
    if (e.key === 'm' || e.key === 'M') {
        if (MapUI.isOpen) {
            MapUI.toggle(false);
        }
    }
});
