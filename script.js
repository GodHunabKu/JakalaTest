const CONTAINER_VOLUME = 33.196;
const CONTAINER_HEIGHT = 240;
const CONTAINER_WIDTH = 600;
const CONTAINER_DEPTH = 240;
const MAX_LENGTH = 1200;
const MAX_WIDTH = 240;
const MAX_HEIGHT = 250;

let totalVolume = 0;
let totalWeight = 0;
let pallets = [];
let selectedPallet = null;
let cameraZoom = 12;

// THREE JS
const scene = new THREE.Scene();
scene.background = new THREE.Color(0x87ceeb);

const camera = new THREE.PerspectiveCamera(75, 800 / 600, 0.1, 1000); // Aspect ratio
const renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setSize(800, 600); // Dimensioni maggiori
renderer.setClearColor(0xffffff);
document.getElementById('container3D').appendChild(renderer.domElement);

const ambientLight = new THREE.AmbientLight(0x404040);
scene.add(ambientLight);

const directionalLight = new THREE.DirectionalLight(0xffffff, 0.5);
directionalLight.position.set(5, 5, 5).normalize();
scene.add(directionalLight);

const containerWidth = 6;
const containerHeight = 2.5;
const containerDepth = 2.4;

const containerMaterial = new THREE.MeshLambertMaterial({
    color: 0x0000FF,
    wireframe: false,
    opacity: 0.5,
    transparent: true
});

const containerGeometry = new THREE.BoxGeometry(containerWidth, containerHeight, containerDepth);
const container3D = new THREE.Mesh(containerGeometry, containerMaterial);
scene.add(container3D);

const groundGeometry = new THREE.PlaneGeometry(20, 20);
const groundMaterial = new THREE.MeshLambertMaterial({ color: 0x696969 });
const ground = new THREE.Mesh(groundGeometry, groundMaterial);
ground.rotation.x = -Math.PI / 2;
ground.position.y = -1.25;
scene.add(ground);

const containerGroup = new THREE.Group();
scene.add(containerGroup);
containerGroup.add(container3D);

camera.position.set(12, 6, 12);
camera.lookAt(containerGroup.position);

const controls = new THREE.OrbitControls(camera, renderer.domElement);
controls.target = new THREE.Vector3(0, 0, 0);
controls.minDistance = 5;
controls.maxDistance = 20;
controls.enablePan = true;
controls.rotateSpeed = 0.5;
controls.zoomSpeed = 0.8;
controls.panSpeed = 0.5;
controls.update();

function displayMessage(message, duration = 3000) {
    const messageElement = document.getElementById('message');
    messageElement.textContent = message;
    setTimeout(() => {
        messageElement.textContent = '';
    }, duration);
}

let isDragging3D = false;
let previousMousePosition = { x: 0, y: 0 };

function setupEventListeners() {
    const container3DElement = document.getElementById('container3D');

    container3DElement.addEventListener('mousedown', handleMouseDown);
    container3DElement.addEventListener('mousemove', handleMouseMove);
    container3DElement.addEventListener('mouseup', handleMouseUp);
    container3DElement.addEventListener('mouseleave', handleMouseLeave);
    document.getElementById('calculateSpace').addEventListener('click', calculateSpaceOccupied);
    document.getElementById('palletForm').addEventListener('submit', addPallet);
    document.getElementById('optimizeLayout').addEventListener('click', optimizeLayout);
    document.getElementById('saveLayout').addEventListener('click', saveLayout);
    document.getElementById('loadLayout').addEventListener('click', loadLayout);
    document.getElementById('rotatePallet').addEventListener('click', rotatePallet);
    document.getElementById('fullscreenButton').addEventListener('click', openFullscreen);
    document.getElementById('zoomIn').addEventListener('click', zoomIn);
    document.getElementById('zoomOut').addEventListener('click', zoomOut);

    window.addEventListener('resize', onWindowResize, false);
    window.addEventListener('keydown', handleKeyDown);

    //Initial Container value to see it
    document.getElementById('containerWidthData').textContent = CONTAINER_WIDTH;
    document.getElementById('containerDepthData').textContent = CONTAINER_DEPTH;
    document.getElementById('containerHeightData').textContent = CONTAINER_HEIGHT;
    document.getElementById('containerVolumeData').textContent = CONTAINER_VOLUME;
}

function onWindowResize() {
    camera.aspect = 800 / 600; // Aspect Ratio
    camera.updateProjectionMatrix();
    renderer.setSize(800, 600);
}

function openFullscreen() {
    const elem = document.getElementById('container3D');
    if (elem.requestFullscreen) {
        elem.requestFullscreen();
    } else if (elem.mozRequestFullScreen) {
        elem.mozRequestFullScreen();
    } else if (elem.webkitRequestFullscreen) {
        elem.webkitRequestFullscreen();
    } else if (elem.msRequestFullscreen) {
        elem.msRequestFullscreen();
    }
}

function zoomIn() {
    cameraZoom -= 1;
    updateCameraPosition();
}

function zoomOut() {
    cameraZoom += 1;
    updateCameraPosition();
}

function updateCameraPosition() {
    cameraZoom = Math.max(5, Math.min(20, cameraZoom));
    camera.position.set(cameraZoom, 6, cameraZoom);
    camera.lookAt(containerGroup.position);
    controls.update();
}

function handleMouseDown(e) {
    isDragging3D = true;
    previousMousePosition = { x: e.offsetX, y: e.offsetY };

    const raycaster = new THREE.Raycaster();
    const mouse = new THREE.Vector2();
    mouse.x = (e.offsetX / 800) * 2 - 1; // Use correct width
    mouse.y = -(e.offsetY / 600) * 2 + 1; // Use correct height

    raycaster.setFromCamera(mouse, camera);
    // Intersect all objects in the scene, including container and pallets
    const intersects = raycaster.intersectObjects(scene.children, true);

    if (intersects.length > 0) {
        // Find the closest pallet intersection
        let closestPallet = null;
        let closestDistance = Infinity;

        for (const intersect of intersects) {
            let pallet = intersect.object.parent;
            while (pallet && !pallet.userData.isPallet) {
                pallet = pallet.parent;
            }

            if (pallet && pallet.userData.isPallet) {
                const distance = intersect.distance;
                if (distance < closestDistance) {
                    closestPallet = pallet;
                    closestDistance = distance;
                }
            }
        }

        if (closestPallet) {
            selectedPallet = closestPallet;
            highlightSelectedPallet(selectedPallet);

            const palletData = pallets.find(p => p.pallet3D === selectedPallet);
            if (palletData) {
                updateSelectedPalletInfo(palletData);
            }
        } else {
            selectedPallet = null;
            clearSelectedPalletInfo();
        }
    } else {
        selectedPallet = null;
        clearSelectedPalletInfo();
    }
}

function handleMouseMove(e) {
    if (isDragging3D) {
        const deltaX = e.offsetX - previousMousePosition.x;
        containerGroup.rotation.y += deltaX * 0.01;
        controls.update();
    }
    previousMousePosition = { x: e.offsetX, y: e.offsetY };
}

function handleMouseUp() {
    isDragging3D = false;
}

function handleMouseLeave() {
    isDragging3D = false;
}

function highlightSelectedPallet(pallet3D) {
    pallets.forEach(p => {
        if (p.pallet3D && p.pallet3D.children.length > 1) {
            const contentMesh = p.pallet3D.children[1];
            if (contentMesh.material) {
                contentMesh.material.color.set(0x00ff00); // Green
            }
        }
    });

    if (pallet3D && pallet3D.children.length > 1) {
        const contentMesh = pallet3D.children[1];
        if (contentMesh.material) {
            contentMesh.material.color.set(0x800080); // Purple
        }
    }
}

function handleKeyDown(event) {
    if (selectedPallet) {
        const moveDistance = 0.1; // Adjust as needed
        switch (event.key) {
            case '8': // Up (Z-axis)
                selectedPallet.position.z -= moveDistance;
                break;
            case '2': // Down (Z-axis)
                selectedPallet.position.z += moveDistance;
                break;
            case '4': // Left (X-axis)
                selectedPallet.position.x -= moveDistance;
                break;
            case '6': // Right (X-axis)
                selectedPallet.position.x += moveDistance;
                break;
            case '+': // Up (Y-axis)
                selectedPallet.position.y += moveDistance;
                break;
            case '-': // Down (Y-axis)
                selectedPallet.position.y -= moveDistance;
                break;
        }
        highlightPallets();
    }
}

function highlightPallets() {
    for (let i = 0; i < pallets.length; i++) {
        const p = pallets[i];
        if (p.pallet3D && p.pallet3D.children.length > 1) {
            const contentMesh = p.pallet3D.children[1];
            if (contentMesh.material) {
                let collisionColor = 0x00ff00;
                let hasCollision = false;
                let touchesContainer = false;

                for (let j = 0; j < pallets.length; j++) {
                    if (i !== j && checkVerticalCollision(pallets[i], pallets[j])) {
                        hasCollision = true;
                        break;
                    }
                }

                if (checkContainerContact(pallets[i])) {
                    touchesContainer = true;
                }

                if (hasCollision && touchesContainer) {
                    collisionColor = 0x000000;
                } else if (hasCollision) {
                    collisionColor = 0xff0000;
                } else if (touchesContainer) {
                    collisionColor = 0xFFA500;
                }

                if (isPalletInsideContainer(p)) {
                    contentMesh.material.color.set(collisionColor);
                } else {
                    contentMesh.material.color.set(0x333333);
                }
            }
        }
    }
}

function isPalletInsideContainer(pallet) {
    const palletWidth = pallet.width / 100;
    const palletLength = pallet.length / 100;
    const palletHeight = pallet.height / 100;

    const containerWidth = 6;
    const containerHeight = 2.5;
    const containerLength = 2.4;

    const palletX = pallet.pallet3D.position.x;
    const palletY = pallet.pallet3D.position.y;
    const palletZ = pallet.pallet3D.position.z;

    return (Math.abs(palletX) + palletWidth / 2 <= containerWidth / 2 &&
        Math.abs(palletZ) + palletLength / 2 <= containerLength / 2 &&
        palletY + palletHeight / 2 <= containerHeight);
}

function checkContainerContact(pallet) {
    if (!pallet.pallet3D) return false;

    const palletWidth = pallet.width / 100;
    const palletLength = pallet.length / 100;
    const palletHeight = pallet.height / 100;

    const containerWidth = 6;
    const containerHeight = 2.5;
    const containerLength = 2.4;

    const palletX = pallet.pallet3D.position.x;
    const palletY = pallet.pallet3D.position.y;
    const palletZ = pallet.pallet3D.position.z;

    return (Math.abs(palletX) + palletWidth / 2 > containerWidth / 2 ||
        Math.abs(palletZ) + palletLength / 2 > containerLength / 2 ||
        palletY + palletHeight / 2 > containerHeight);
}

function checkVerticalCollision(pallet1, pallet2) {
    if (!pallet1.pallet3D || !pallet2.pallet3D) return false;

    const y1 = pallet1.pallet3D.position.y - (pallet1.height / 200);
    const y2 = pallet2.pallet3D.position.y - (pallet2.height / 200);

    const height1 = pallet1.height / 100;
    const height2 = pallet2.height / 100;

    return (y1 < y2 + height2 && y1 + height1 > y2);
}

function addPalletTo3D(length, width, height, x, y, palletHeight, rotation) {
    const palletGroup = new THREE.Group();
    palletGroup.userData.isPallet = true;

    const baseMaterial = new THREE.MeshLambertMaterial({ color: 0x8B4513 });
    const contentMaterial = new THREE.MeshLambertMaterial({ color: 0x00ff00 });

    const baseThickness = 0.1;

    const baseGeometry = new THREE.BoxGeometry(width / 100, baseThickness, length / 100);
    const base = new THREE.Mesh(baseGeometry, baseMaterial);
    base.position.y = baseThickness / 2;

    const contentGeometry = new THREE.BoxGeometry(width / 100, height / 100, length / 100);
    const content = new THREE.Mesh(contentGeometry, contentMaterial);
    content.position.y = height / 200 + baseThickness / 2;

    palletGroup.add(base);
    palletGroup.add(content);

    const posX = ((x / (CONTAINER_WIDTH / 2)) - 1) * (containerWidth / 2);
    const posZ = -((y / (CONTAINER_DEPTH / 2)) - 1) * (containerDepth / 2);

    palletGroup.position.set(posX, (palletHeight / 100) + baseThickness / 2, posZ);
    palletGroup.rotation.y = rotation;

    containerGroup.add(palletGroup);

    return palletGroup;
}

function addPallet(event) {
    event.preventDefault();

    const type = document.getElementById('palletType').value;
    const length = parseFloat(document.getElementById('palletLength').value);
    const width = parseFloat(document.getElementById('palletWidth').value);
    const height = parseFloat(document.getElementById('palletHeight').value);
    const weight = parseFloat(document.getElementById('palletWeight').value);
    const canStack = document.getElementById('canStack').checked;

    if (isNaN(length) || isNaN(width) || isNaN(height) || isNaN(weight)) {
        alert("Please enter valid numbers for dimensions and weight.");
        return;
    }

    if (length > MAX_LENGTH || width > MAX_WIDTH || height > MAX_HEIGHT) {
        alert("Dimensioni del bancale superano i limiti del container.");
        return;
    }

    const volume = (length * width * height) / 1000000;
    totalVolume += volume;
    totalWeight += weight;

    updateResults();

    let initialPalletHeight = 0; // Inizializza a 0
    const initialRotation = 0;

    const palletData = { //Definisci palletData prima
        type,
        length,
        width,
        height,
        weight,
        canStack,
        x: 0,
        y: 0,
        rotation: initialRotation,
        palletHeight: initialPalletHeight,
        element: null
    };

    // **NUOVA LOGICA DI SOVRAPPOSIZIONE**
    if (canStack) {
        // Find a suitable pallet to stack on
        let stacked = false;
        for (const existingPallet of pallets) {
            if (existingPallet.canStack && isPalletInsideContainer(palletData) && isPalletInsideContainer(existingPallet)) {
                //Posiziona il bancale sopra l'esistente
                initialPalletHeight = existingPallet.palletHeight + (existingPallet.height / 100); //Aggiorna l'altezza
                palletData.palletHeight = initialPalletHeight; //Aggiorna anche il valore in palletData
                stacked = true;
                break;
            }
        }
    }

    const pallet3D = addPalletTo3D(length, width, height, 0, 0, initialPalletHeight, initialRotation); //Chiama addPalletTo3D qui
    palletData.pallet3D = pallet3D; //Salva il pallet3D in palletData
    pallet3D.position.y = initialPalletHeight; //Imposta l'altezza del pallet3D
    pallets.push(palletData);

    addPalletToList(type, length, width, height, weight, canStack, pallets.length - 1);

    document.getElementById('palletForm').reset();
    highlightPallets();
}

function addPalletToList(type, length, width, height, weight, canStack, index) {
    const listItem = document.createElement('li');
    listItem.id = `pallet-list-item-${index}`; // Unique ID for each list item
    listItem.innerHTML = `
        Bancale ${index + 1}: ${type}, ${length}x${width}x${height} cm, ${weight} kg, Sovrapponibile: ${canStack ? 'Si' : 'No'}
        <button onclick="removePallet(${index})">Elimina</button>
    `;
    listItem.addEventListener('click', () => selectPalletFromList(index)); // Add click event
    document.getElementById('bancaliList').appendChild(listItem);
}

function updateResults() {
    document.getElementById('totalVolume').textContent = totalVolume.toFixed(2);
    document.getElementById('totalWeight').textContent = totalWeight.toFixed(2);
    document.getElementById('spaceUsed').textContent = ((totalVolume / CONTAINER_VOLUME) * 100).toFixed(2);
}

function selectPalletFromList(index) {
    const palletData = pallets[index];
    if (palletData) {
        selectedPallet = palletData.pallet3D;
        highlightSelectedPallet(selectedPallet);
        updateSelectedPalletInfo(palletData);
    }
}

function updateSelectedPalletInfo(palletData) {
    document.getElementById('selectedPalletType').textContent = palletData.type;
    document.getElementById('selectedPalletLength').textContent = palletData.length;
    document.getElementById('selectedPalletWidth').textContent = palletData.width;
    document.getElementById('selectedPalletHeight').textContent = palletData.height;
    document.getElementById('selectedPalletWeight').textContent = palletData.weight;
}

function clearSelectedPalletInfo() {
    document.getElementById('selectedPalletType').textContent = '';
    document.getElementById('selectedPalletLength').textContent = '';
    document.getElementById('selectedPalletWidth').textContent = '';
    document.getElementById('selectedPalletHeight').textContent = '';
    document.getElementById('selectedPalletWeight').textContent = '';
}

function rotatePallet() {
    if (selectedPallet) {
        const palletData = pallets.find(p => p.pallet3D === selectedPallet);
        if (palletData) {
            palletData.rotation += Math.PI / 2;
            palletData.pallet3D.rotation.y = palletData.rotation;
            highlightPallets();
        }
    }
}

function optimizeLayout() {
    //TODO implement logic to optimize
    displayMessage('Ottimizzazione non implementata!')
}

function saveLayout() {
    const layoutData = pallets.map(palletData => {
        return {
            type: palletData.type,
            length: palletData.length,
            width: palletData.width,
            height: palletData.height,
            weight: palletData.weight,
            canStack: palletData.canStack, //Save the canStack attribute
            x: palletData.x,
            y: palletData.y,
            rotation: palletData.rotation,
            palletHeight: palletData.palletHeight,
            position: {
                x: palletData.pallet3D.position.x,
                y: palletData.pallet3D.position.y,
                z: palletData.pallet3D.position.z
            }
        };
    });
    localStorage.setItem('containerLayout', JSON.stringify(layoutData));
    displayMessage('Layout salvato!');
}

function loadLayout() {
    const savedLayout = localStorage.getItem('containerLayout');
    if (savedLayout) {
        pallets.forEach(palletData => {
            if (palletData.pallet3D) {
                containerGroup.remove(palletData.pallet3D);
            }
        });
        pallets = [];
        totalVolume = 0;
        totalWeight = 0;
        document.getElementById('bancaliList').innerHTML = '';

        const layoutData = JSON.parse(savedLayout);

        layoutData.forEach(data => {
            const pallet3D = addPalletTo3D(data.length, data.width, data.height, data.x, data.y, data.palletHeight, data.rotation);

            pallet3D.position.set(data.position.x, data.position.y, data.position.z)

            const palletData = {
                pallet3D,
                type: data.type,
                length: data.length,
                width: data.width,
                height: data.height,
                weight: data.weight,
                canStack: data.canStack, //Load the canStack attribute
                x: data.x,
                y: data.y,
                rotation: data.rotation,
                palletHeight: data.palletHeight,
                element: null
            };

            pallets.push(palletData);

            addPalletToList(data.type, data.length, data.width, data.height, data.weight, data.canStack, pallets.length - 1);

            totalVolume += (data.length * data.width * data.height) / 1000000;
            totalWeight += data.weight;
        });
        updateResults();
        displayMessage('Layout caricato!');
    } else {
        displayMessage('Nessun layout salvato trovato.');
    }
    highlightPallets();
}

function calculateSpaceOccupied() {
    highlightPallets();

    // Filter pallets that are inside the container
    const palletsInsideContainer = pallets.filter(pallet => isPalletInsideContainer(pallet));

    let occupiedVolume = 0;

    palletsInsideContainer.forEach(pallet => {
        occupiedVolume += (pallet.length * pallet.width * pallet.height) / 1000000;
    });

    const occupiedVolumeMeters = occupiedVolume;
    const spaceUsedPercentage = (occupiedVolumeMeters / CONTAINER_VOLUME) * 100;

    displayMessage(`Spazio Occupato: ${spaceUsedPercentage.toFixed(2)}%`);
    document.getElementById('spaceUsed').textContent = spaceUsedPercentage.toFixed(2);
}

const openFrontal = () => {
    container3D.geometry.clearGroups();
}

function animate() {
    requestAnimationFrame(animate);
    controls.update();
    renderer.render(scene, camera);
}

function removePallet(index) {
    const palletToRemove = pallets[index];

    if (palletToRemove) {
        // Remove from 3D scene
        containerGroup.remove(palletToRemove.pallet3D);

        // Update total volume and weight
        totalVolume -= (palletToRemove.length * palletToRemove.width * palletToRemove.height) / 1000000;
        totalWeight -= palletToRemove.weight;

        // Remove from the pallets array
        pallets.splice(index, 1);

        // Update the UI
        updateResults();
        updatePalletList();
        highlightPallets();

        selectedPallet = null;
        clearSelectedPalletInfo();
    }
}

function updatePalletList() {
    const bancaliList = document.getElementById('bancaliList');
    bancaliList.innerHTML = '';  // Clear the current list

    pallets.forEach((pallet, index) => {
        addPalletToList(pallet.type, pallet.length, pallet.width, pallet.height, pallet.weight, pallet.canStack, index);
    });
}

//Setup
setupEventListeners();
openFrontal();
animate();