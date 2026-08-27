const TeamUI = {
    init() {},

    updateHUD(teamData) {
        const hud = document.getElementById('team-hud');
        if (!teamData) {
            if (hud) hud.classList.add('hidden');
            return;
        }

        if (hud) hud.classList.remove('hidden');

        const nameEl = document.getElementById('hud-team-name');
        const logoEl = document.getElementById('hud-team-logo');
        if (nameEl) nameEl.innerText = teamData.name || "SQUAD";
        if (logoEl) logoEl.src = teamData.logo || "assets/images/default_team.png";

        const list = document.getElementById('hud-members-list');
        if (!list) return;

        list.innerHTML = '';

        if (teamData.members && Array.isArray(teamData.members)) {
            teamData.members.forEach((member, index) => {
                const badgeNum = index + 1;
                const badgeClass = badgeNum <= 4 ? `badge-${badgeNum}` : '';
                const health = member.health !== undefined ? member.health : 100;
                const isDowned = member.state === 'DOWNED' || health <= 0;

                const row = document.createElement('div');
                row.className = 'squad-card-row';
                row.innerHTML = `
                    <div class="squad-card-top">
                        <span class="squad-number-badge ${badgeClass}">${badgeNum}</span>
                        <span class="squad-player-name">${member.name || ('Player ' + (member.source || badgeNum))}</span>
                        <img src="icon/Vector.png" alt="Gun" class="squad-img-icon">
                    </div>
                    <div class="squad-card-bottom">
                        <div class="squad-health-fill ${isDowned ? 'downed' : ''}" style="width: ${isDowned ? 100 : health}%"></div>
                    </div>
                `;
                list.appendChild(row);
            });
        }
    }
};

document.addEventListener('DOMContentLoaded', () => TeamUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'updateTeamHUD') {
        TeamUI.updateHUD(event.data.team);
    }
});
