const HUD = {
    init() {},

    updatePlayerHUD(data) {
        if (!data) return;
        const hud = document.getElementById('player-hud');
        if (hud) hud.classList.remove('hidden');

        // Health Fill Bar
        const hpFill = document.getElementById('hud-health-fill');
        if (hpFill) {
            hpFill.style.width = `${Math.min(100, Math.max(0, data.health))}%`;
        }

        // Ammo Text (Clip / Reserve)
        const ammoText = document.getElementById('hud-ammo-text');
        if (ammoText) {
            ammoText.innerText = `${data.clipAmmo || 0}/${data.reserveAmmo || 0}`;
        }

        // Sprint Icon Highlight
        const sprintIcon = document.getElementById('hud-sprint-icon');
        if (sprintIcon) {
            if (data.isSprinting) {
                sprintIcon.classList.add('active-stat');
            } else {
                sprintIcon.classList.remove('active-stat');
            }
        }

        // Vest Icon Highlight
        const vestIcon = document.getElementById('hud-vest-icon');
        if (vestIcon) {
            if (data.hasArmor) {
                vestIcon.classList.add('active-stat');
                vestIcon.title = `Armor: ${data.armor}%`;
            } else {
                vestIcon.classList.remove('active-stat');
                vestIcon.title = "No Armor";
            }
        }

        // Helmet Icon Highlight
        const helmetIcon = document.getElementById('hud-helmet-icon');
        if (helmetIcon) {
            if (data.hasHelmet) {
                helmetIcon.classList.add('active-stat');
                helmetIcon.title = "Helmet Equipped";
            } else {
                helmetIcon.classList.remove('active-stat');
                helmetIcon.title = "No Helmet";
            }
        }

        // Weapon Icon & Tooltip
        const weaponIcon = document.getElementById('hud-weapon-icon');
        if (weaponIcon) {
            weaponIcon.title = data.weaponName || "UNARMED";
            if (data.weaponName && data.weaponName !== "UNARMED") {
                weaponIcon.classList.add('active-stat');
            } else {
                weaponIcon.classList.remove('active-stat');
            }
        }
    },

    updateSquadHUD(teamData) {
        const hud = document.getElementById('team-hud');
        if (!teamData || !teamData.members) {
            if (hud) hud.classList.add('hidden');
            return;
        }

        if (hud) hud.classList.remove('hidden');

        // Dynamic Team Header Name & Logo
        const teamNameEl = document.getElementById('hud-team-name');
        if (teamNameEl && teamData.name) {
            teamNameEl.innerText = teamData.name;
        }

        const teamLogoEl = document.getElementById('hud-team-logo');
        if (teamLogoEl && teamData.logo) {
            teamLogoEl.src = teamData.logo;
        }

        const list = document.getElementById('hud-members-list');
        if (!list) return;

        list.innerHTML = '';

        teamData.members.forEach((member, index) => {
            const badgeNumber = (index % 4) + 1;
            const card = document.createElement('div');
            card.className = 'squad-card-row';

            card.innerHTML = `
                <div class="squad-card-top">
                    <span class="squad-number-badge badge-${badgeNumber}">${badgeNumber}</span>
                    <span class="squad-player-name">${member.name || ('player ' + member.source)}</span>
                    <img src="icon/Vector.png" alt="Gun" class="squad-img-icon">
                </div>
                <div class="squad-card-bottom">
                    <div class="squad-health-fill ${member.state === 'DOWNED' ? 'downed' : ''}" style="width: ${member.health || 100}%"></div>
                </div>
            `;
            list.appendChild(card);
        });
    }
};

document.addEventListener('DOMContentLoaded', () => HUD.init());

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'updatePlayerHUD') {
        HUD.updatePlayerHUD(data);
    } else if (data.action === 'updateTeamHUD') {
        HUD.updateSquadHUD(event.data.team);
    }
});
