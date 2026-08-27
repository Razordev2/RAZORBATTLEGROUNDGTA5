const EliminationUI = {
    init() {},

    show(data) {
        if (!data) return;
        const container = document.getElementById('elimination-container');
        document.getElementById('elim-rank').innerText = `#${data.rank || 10}`;
        document.getElementById('elim-team-name').innerText = data.teamName || "TEAM";
        document.getElementById('elim-logo').src = data.logo || "assets/images/default_team.png";

        container.classList.remove('hidden');
        setTimeout(() => {
            container.classList.add('hidden');
        }, 4000);
    }
};

document.addEventListener('DOMContentLoaded', () => EliminationUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'showTeamEliminated') {
        EliminationUI.show(event.data.elimination);
    }
});
