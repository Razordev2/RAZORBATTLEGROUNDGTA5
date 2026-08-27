const InventoryUI = {
    selectedItem: null,
    inventoryData: { weapons: {}, items: {} },
    nearbySquadmates: [],

    init() {
        const closeBtn = document.getElementById('btn-close-inventory');
        if (closeBtn) {
            closeBtn.addEventListener('click', () => sendNuiCallback('closeInventoryUI'));
        }

        const minusBtn = document.getElementById('btn-amount-minus');
        if (minusBtn) {
            minusBtn.addEventListener('click', () => this.stepAmount(-1));
        }

        const plusBtn = document.getElementById('btn-amount-plus');
        if (plusBtn) {
            plusBtn.addEventListener('click', () => this.stepAmount(1));
        }

        const giveBtn = document.getElementById('btn-action-give');
        if (giveBtn) {
            giveBtn.addEventListener('click', () => this.handleGiveAction());
        }

        const useBtn = document.getElementById('btn-action-use');
        if (useBtn) {
            useBtn.addEventListener('click', () => {
                if (!this.selectedItem) {
                    showNotification("Select an item first", "error");
                    return;
                }

                sendNuiCallback('useItem', {
                    itemName: this.selectedItem.name
                });
            });
        }

        const dropBtn = document.getElementById('btn-action-drop');
        if (dropBtn) {
            dropBtn.addEventListener('click', () => sendNuiCallback('closeInventoryUI'));
        }

        // Give Target Modal Controls
        const closeGiveModal = document.getElementById('btn-close-give-modal');
        const cancelGiveModal = document.getElementById('btn-cancel-give-modal');
        if (closeGiveModal) closeGiveModal.addEventListener('click', () => this.toggleGiveModal(false));
        if (cancelGiveModal) cancelGiveModal.addEventListener('click', () => this.toggleGiveModal(false));

        const confirmGiveModal = document.getElementById('btn-confirm-give-modal');
        if (confirmGiveModal) {
            confirmGiveModal.addEventListener('click', () => {
                const select = document.getElementById('select-target-player');
                const targetSrc = select ? parseInt(select.value) : null;
                if (targetSrc) {
                    this.executeGive(targetSrc);
                    this.toggleGiveModal(false);
                } else {
                    showNotification("Select a squadmate", "error");
                }
            });
        }

        // Attach click handlers to preset static slots
        document.querySelectorAll('.inv-slot:not(.empty)').forEach((slot) => {
            slot.addEventListener('click', () => {
                const name = slot.getAttribute('data-name');
                const type = slot.getAttribute('data-type') || 'ITEM';
                const count = parseInt(slot.getAttribute('data-count')) || 1;
                if (name) {
                    this.selectItem({ name: name, itemType: type, count: count }, slot);
                }
            });
        });
    },

    stepAmount(val) {
        const input = document.getElementById('input-item-amount');
        if (!input) return;
        let cur = parseInt(input.value) || 1;
        cur = Math.max(1, cur + val);
        input.value = cur;
    },

    handleGiveAction() {
        if (!this.selectedItem) {
            showNotification("Select an item first", "error");
            return;
        }

        const squad = this.nearbySquadmates || [];

        if (squad.length === 0) {
            showNotification("No squadmates nearby to give items", "error");
            return;
        }

        if (squad.length === 1) {
            // Exactly 1 player: Give directly!
            this.executeGive(squad[0].source);
        } else {
            // More than 1 player (> 1): Show modal selector UI!
            this.populateTargetSelect(squad);
            this.toggleGiveModal(true);
        }
    },

    executeGive(targetSrc) {
        const amountInput = document.getElementById('input-item-amount');
        const count = parseInt(amountInput ? amountInput.value : 1) || 1;

        sendNuiCallback('giveItem', {
            targetSrc: targetSrc,
            itemType: this.selectedItem.itemType,
            itemName: this.selectedItem.name,
            count: count
        });
    },

    toggleGiveModal(show) {
        const modal = document.getElementById('give-target-modal');
        if (!modal) return;
        if (show) modal.classList.remove('hidden');
        else modal.classList.add('hidden');
    },

    populateTargetSelect(squadMembers) {
        const select = document.getElementById('select-target-player');
        if (!select) return;
        select.innerHTML = '';

        squadMembers.forEach(member => {
            const opt = document.createElement('option');
            opt.value = member.source;
            opt.innerText = `${member.name} (ID: ${member.source})`;
            select.appendChild(opt);
        });
    },

    toggle(show, inventory) {
        const container = document.getElementById('inventory-container');
        if (show) {
            container.classList.remove('hidden');
            if (inventory) this.updateInventory(inventory);
        } else {
            container.classList.add('hidden');
            this.toggleGiveModal(false);
        }
    },

    calculateCapacity(inventory) {
        let maxCap = 10.0; // Base pockets capacity when parachuting without backpack
        let curWeight = 0.0;

        const items = inventory.items || {};
        const weapons = inventory.weapons || {};

        // Determine Max Capacity from Backpack Loot
        if (items['backpack_lvl3'] && items['backpack_lvl3'] > 0) {
            maxCap = 110.0; // Level 3 Backpack (+100.0 KG)
        } else if (items['backpack_lvl2'] && items['backpack_lvl2'] > 0) {
            maxCap = 70.0;  // Level 2 Backpack (+60.0 KG)
        } else if (items['backpack_lvl1'] && items['backpack_lvl1'] > 0) {
            maxCap = 40.0;  // Level 1 Backpack (+30.0 KG)
        }

        // Calculate Carried Weight from Weapons
        Object.keys(weapons).forEach(wName => {
            if (wName.includes('PISTOL')) curWeight += 1.5;
            else curWeight += 4.0;
        });

        // Calculate Carried Weight from Items
        Object.entries(items).forEach(([itemName, count]) => {
            if (count > 0) {
                if (itemName.includes('medkit')) curWeight += count * 1.5;
                else if (itemName.includes('bandage')) curWeight += count * 0.5;
                else if (itemName.includes('armor')) curWeight += count * 3.0;
                else if (itemName.includes('ammo')) curWeight += count * 0.05;
            }
        });

        // Update Capacity Bar UI
        const weightTextEl = document.getElementById('inv-weight-text');
        const fillEl = document.querySelector('.inv-panel-left .capacity-fill');

        if (weightTextEl) {
            weightTextEl.innerText = `${curWeight.toFixed(1)} / ${maxCap.toFixed(1)} kg`;
        }

        if (fillEl) {
            const pct = Math.min(100, (curWeight / maxCap) * 100);
            fillEl.style.width = `${pct}%`;
            if (curWeight > maxCap) {
                fillEl.style.background = '#ef4444';
            } else {
                fillEl.style.background = '#f59e0b';
            }
        }
    },

    updateInventory(inventory) {
        this.inventoryData = inventory || { weapons: {}, items: {} };
        this.calculateCapacity(this.inventoryData);

        const grid = document.getElementById('inventory-left-grid');
        if (!grid) return;

        grid.innerHTML = '';
        let hotkeyIndex = 1;

        // Render Weapons
        if (inventory.weapons) {
            Object.keys(inventory.weapons).forEach(wName => {
                const slot = document.createElement('div');
                slot.className = 'inv-slot';
                const hotkeyHtml = hotkeyIndex <= 5 ? `<span class="slot-hotkey">${hotkeyIndex}</span>` : '';
                hotkeyIndex++;

                slot.innerHTML = `
                    ${hotkeyHtml}
                    <span class="slot-count">x1</span>
                    <img src="icon/Vector.png" alt="Weapon" class="slot-img">
                    <span class="slot-name-tag">${wName.replace('WEAPON_', '')}</span>
                `;
                slot.addEventListener('click', () => this.selectItem({ name: wName, itemType: 'WEAPON', count: 1 }, slot));
                grid.appendChild(slot);
            });
        }

        // Render Items (Medical, Armor, Ammo, Backpacks)
        if (inventory.items) {
            Object.entries(inventory.items).forEach(([itemName, count]) => {
                if (count > 0) {
                    const slot = document.createElement('div');
                    slot.className = 'inv-slot';
                    const hotkeyHtml = hotkeyIndex <= 5 ? `<span class="slot-hotkey">${hotkeyIndex}</span>` : '';
                    hotkeyIndex++;

                    let iconContent = '<span class="slot-text-icon">ITEM</span>';
                    if (itemName.includes('medkit')) iconContent = '<span class="slot-text-icon">MEDKIT</span>';
                    else if (itemName.includes('bandage')) iconContent = '<span class="slot-text-icon">BANDAGE</span>';
                    else if (itemName.includes('ammo')) iconContent = '<span class="slot-text-icon">AMMO</span>';
                    else if (itemName.includes('armor')) iconContent = '<img src="icon/Vector-1.png" alt="Armor" class="slot-img">';
                    else if (itemName.includes('backpack')) iconContent = '<span class="slot-text-icon">BACKPACK</span>';

                    slot.innerHTML = `
                        ${hotkeyHtml}
                        <span class="slot-count">x${count}</span>
                        ${iconContent}
                        <span class="slot-name-tag">${itemName}</span>
                    `;
                    slot.addEventListener('click', () => this.selectItem({ name: itemName, itemType: 'ITEM', count: count }, slot));
                    grid.appendChild(slot);
                }
            });
        }

        // Fill remaining empty slots up to 15 (5x3)
        const totalItems = Object.keys(inventory.weapons || {}).length + Object.keys(inventory.items || {}).length;
        for (let i = totalItems; i < 15; i++) {
            const emptySlot = document.createElement('div');
            emptySlot.className = 'inv-slot empty';
            grid.appendChild(emptySlot);
        }
    },

    selectItem(item, slotEl) {
        document.querySelectorAll('.inv-slot').forEach(s => s.classList.remove('selected'));
        if (slotEl) slotEl.classList.add('selected');
        this.selectedItem = item;
    },

    updateTargetPlayers(squadMembers) {
        this.nearbySquadmates = squadMembers || [];
    }
};

document.addEventListener('DOMContentLoaded', () => InventoryUI.init());

window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.action === 'toggleInventoryUI') {
        InventoryUI.toggle(data.show, data.inventory);
    } else if (data.action === 'updateCurrentRoom' && data.room) {
        const myTeam = Object.values(data.room.teams || {})[0];
        if (myTeam) {
            InventoryUI.updateTargetPlayers(myTeam.members);
        }
    }
});
