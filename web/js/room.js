const RoomUI = {
    currentRoom: null,

    init() {
        document.getElementById('btn-close-room').addEventListener('click', () => {
            sendNuiCallback('closeRoomUI');
        });

        document.getElementById('btn-open-create-modal').addEventListener('click', () => {
            document.getElementById('create-room-modal').classList.remove('hidden');
        });

        const closeCreateModalBtn = document.getElementById('btn-close-create-room-modal');
        if (closeCreateModalBtn) {
            closeCreateModalBtn.addEventListener('click', () => {
                document.getElementById('create-room-modal').classList.add('hidden');
                sendNuiCallback('closeCreateTeamUI');
            });
        }

        document.getElementById('btn-cancel-create-room').addEventListener('click', () => {
            document.getElementById('create-room-modal').classList.add('hidden');
            sendNuiCallback('closeCreateTeamUI');
        });

        document.getElementById('btn-confirm-create-room').addEventListener('click', () => {
            const name = document.getElementById('create-room-name').value;
            const password = document.getElementById('create-room-pass').value;
            const logoUrl = document.getElementById('create-room-logo').value;

            sendNuiCallback('createRoom', { name, password, logoUrl });
            document.getElementById('create-room-modal').classList.add('hidden');
        });

        document.getElementById('btn-leave-room').addEventListener('click', () => {
            sendNuiCallback('leaveRoom');
        });

        document.getElementById('btn-create-team').addEventListener('click', () => {
            const name = document.getElementById('input-team-name').value;
            const logoUrl = document.getElementById('input-team-logo').value;
            sendNuiCallback('createTeam', { name, logoUrl });
        });

        document.getElementById('btn-start-match').addEventListener('click', () => {
            sendNuiCallback('startMatch');
        });

        // Search Filter
        const searchInput = document.getElementById('input-search-team');
        if (searchInput) {
            searchInput.addEventListener('input', (e) => {
                const query = e.target.value.toLowerCase();
                document.querySelectorAll('#team-list-container .squad-card-item').forEach(card => {
                    const text = card.innerText.toLowerCase();
                    if (text.includes(query)) {
                        card.style.display = 'flex';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        }
    },

    toggle(show) {
        const container = document.getElementById('room-container');
        if (show) {
            container.classList.remove('hidden');
        } else {
            container.classList.add('hidden');
        }
    },

    toggleCreateModal(show) {
        const modal = document.getElementById('create-room-modal');
        if (!modal) return;
        if (show) modal.classList.remove('hidden');
        else modal.classList.add('hidden');
    },

    updateRoomList(rooms) {
        const container = document.getElementById('team-list-container');
        if (!container) return;
        container.innerHTML = '';

        if (!rooms || rooms.length === 0) {
            container.innerHTML = '<div style="text-align:center; padding: 20px; color:#94a3b8; font-weight:700;">Tidak ada tim player aktif saat ini.</div>';
            return;
        }

        rooms.forEach(room => {
            const card = document.createElement('div');
            card.className = 'squad-card-item';
            card.innerHTML = `
                <div class="squad-card-left">
                    <div class="squad-avatar-wrapper">
                        <img src="${room.logo || 'assets/images/default_team.png'}" class="squad-avatar-img" alt="Logo" onerror="this.src='assets/images/default_team.png'">
                    </div>
                    <div class="squad-title-box">
                        <h3 class="squad-name-title">${room.name} ${room.hasPassword ? '<span class="lock-tag">🔒</span>' : ''}</h3>
                        <span class="squad-subtitle">${room.hasPassword ? 'PASSWORD PROTECTED' : 'PUBLIC SQUAD'}</span>
                    </div>
                </div>
                <button class="btn-join-tim-card" onclick="RoomUI.promptJoin('${room.id}', ${room.hasPassword})">JOIN TIM</button>
            `;
            container.appendChild(card);
        });
    },

    promptJoin(roomId, hasPassword) {
        let password = "";
        if (hasPassword) {
            password = prompt("Enter Room Password:");
            if (password === null) return;
        }
        sendNuiCallback('joinRoom', { roomId, password });
    },

    updateCurrentRoom(room) {
        this.currentRoom = room;
        const browserView = document.getElementById('room-browser-view');
        const activeView = document.getElementById('active-room-view');

        if (!room) {
            browserView.classList.remove('hidden');
            activeView.classList.add('hidden');
            return;
        }

        browserView.classList.add('hidden');
        activeView.classList.remove('hidden');

        document.getElementById('room-title').innerText = room.name;
        document.getElementById('room-id-tag').innerText = `TIM ID: #${room.id}`;

        // Render Teams
        const grid = document.getElementById('teams-grid');
        grid.innerHTML = '';

        Object.values(room.teams).forEach(team => {
            const card = document.createElement('div');
            card.className = 'team-card';
            card.innerHTML = `
                <div class="team-card-header">
                    <img src="${team.logo || 'assets/images/default_team.png'}" class="team-card-logo" onerror="this.src='assets/images/default_team.png'">
                    <div>
                        <strong>${team.name}</strong>
                    </div>
                </div>
                <div class="team-members">
                    ${team.members.map(m => `<div class="team-member-item">👤 Player ${m} ${m === team.leader ? ' (LEADER)' : ''}</div>`).join('')}
                </div>
                <button class="btn btn-secondary btn-sm" style="margin-top:10px; width:100%;" onclick="sendNuiCallback('joinTeam', { teamId: '${team.id}' })">JOIN SQUAD</button>
            `;
            grid.appendChild(card);
        });
    }
};

document.addEventListener('DOMContentLoaded', () => RoomUI.init());

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'toggleRoomUI') {
        RoomUI.toggle(data.show);
    } else if (data.action === 'openCreateTeamUI') {
        RoomUI.toggleCreateModal(data.show);
    } else if (data.action === 'updateRoomList') {
        RoomUI.updateRoomList(data.rooms);
    } else if (data.action === 'updateCurrentRoom') {
        RoomUI.updateCurrentRoom(data.room);
    }
});
