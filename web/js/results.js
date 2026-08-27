const ResultsUI = {
    init() {
        const closeBtn = document.getElementById('btn-close-results');
        if (closeBtn) {
            closeBtn.addEventListener('click', () => {
                document.getElementById('results-container').classList.add('hidden');
                sendNuiCallback('closeResultsUI');
            });
        }
    },

    show(data) {
        const container = document.getElementById('results-container');
        if (!container) return;

        const teamsBody = document.getElementById('arena-teams-tbody');
        const playersBody = document.getElementById('arena-players-tbody');

        if (data && data.teams && teamsBody) {
            teamsBody.innerHTML = '';
            data.teams.forEach((t, index) => {
                const rankNum = index + 1;
                const rankClass = rankNum === 1 ? 'rank-gold' : (rankNum === 2 ? 'rank-silver' : (rankNum === 3 ? 'rank-bronze' : ''));

                const tr = document.createElement('tr');
                tr.className = `arena-row ${index === 0 ? 'active-team-row' : ''}`;
                tr.innerHTML = `
                    <td><span class="rank-num ${rankClass}">${rankNum}</span></td>
                    <td class="team-cell">
                        <img src="${t.logo || 'assets/images/default_team.png'}" class="arena-avatar" alt="Logo" onerror="this.src='assets/images/default_team.png'">
                        <span class="arena-name">${t.teamName || 'NAMA TIM'}</span>
                    </td>
                    <td class="stat-num">${t.kills || 0}</td>
                    <td class="stat-num">${t.knocks || 0}</td>
                    <td class="stat-num">${t.members || 1}</td>
                    <td class="stat-num highlight-points">${t.points || 0}</td>
                `;
                teamsBody.appendChild(tr);
            });
        }

        if (data && data.players && playersBody) {
            playersBody.innerHTML = '';
            data.players.forEach((p, index) => {
                const rankNum = index + 1;
                const rankClass = rankNum === 1 ? 'rank-gold' : (rankNum === 2 ? 'rank-silver' : (rankNum === 3 ? 'rank-bronze' : ''));

                const tr = document.createElement('tr');
                tr.className = 'arena-row';
                tr.innerHTML = `
                    <td><span class="rank-num ${rankClass}">${rankNum}</span></td>
                    <td class="player-cell">
                        <img src="${p.logo || 'assets/images/default_team.png'}" class="arena-avatar" alt="Logo" onerror="this.src='assets/images/default_team.png'">
                        <div class="player-info-box">
                            <span class="arena-name">${p.name || 'NAMA PLAYER'}</span>
                            <span class="arena-subteam">${p.teamName || 'NAMA TIM'}</span>
                        </div>
                    </td>
                    <td class="stat-num">${p.kills || 0}</td>
                    <td class="stat-num">${p.knocks || 0}</td>
                `;
                playersBody.appendChild(tr);
            });
        }

        container.classList.remove('hidden');
    }
};

document.addEventListener('DOMContentLoaded', () => ResultsUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'showResults') {
        ResultsUI.show(event.data);
    }
});
