const CountdownUI = {
    init() {},

    update(seconds) {
        const container = document.getElementById('countdown-container');
        const digit = document.getElementById('countdown-digit');

        if (seconds < 0) {
            container.classList.add('hidden');
            return;
        }

        container.classList.remove('hidden');
        digit.classList.remove('pulse', 'go');

        if (seconds === 0) {
            digit.innerText = "GO!";
            digit.classList.add('go');
            setTimeout(() => {
                container.classList.add('hidden');
            }, 1500);
        } else {
            digit.innerText = seconds;
            digit.classList.add('pulse');
        }
    }
};

document.addEventListener('DOMContentLoaded', () => CountdownUI.init());

window.addEventListener('message', (event) => {
    if (event.data.action === 'updateCountdown') {
        CountdownUI.update(event.data.seconds);
    } else if (event.data.action === 'hideCountdown') {
        CountdownUI.update(-1);
    }
});
