document.addEventListener('DOMContentLoaded', function() {
    let matrixSize = 2;
    const maxSize = 6; // Tamaño máximo de la matriz
    const matrixSizeDisplay = document.getElementById('matrixSize');
    const matrixContainer = document.getElementById('matrixContainer');
    const vectorContainer = document.getElementById('vectorContainer');
    const xContainer = document.getElementById('x0Container');
    const matrixDataInput = document.getElementById('A');
    const vectorDataInput = document.getElementById('b');
    const xDataInput = document.getElementById('x');

    function generateMatrixVector(size) {
        matrixContainer.innerHTML = ''; // Limpiar la matriz anterior
        vectorContainer.innerHTML = ''; // Limpiar el vector anterior
        xContainer.innerHTML = ''; // Limpiar el vector anterior

        //Creación matriz
        const table = document.createElement('table');
        for (let i = 0; i < size; i++) {
            const row = document.createElement('tr');
            for (let j = 0; j < size; j++) {
                const cell = document.createElement('td');
                const input = document.createElement('input');
                input.className = 'matrix-input';
                cell.appendChild(input);
                row.appendChild(cell);
            }
            table.appendChild(row);
        }

        //Creación vector
        const tablev = document.createElement('table');
        for (let i = 0; i < size; i++) {
            const row = document.createElement('tr');
            const cell = document.createElement('td');
            const input = document.createElement('input');
            input.className = 'vector-input';
            cell.appendChild(input);
            row.appendChild(cell);
            tablev.appendChild(row);
        }

        //Creación x0
        const tablex = document.createElement('table');
        for (let i = 0; i < size; i++) {
            const row = document.createElement('tr');
            const cell = document.createElement('td');
            const input = document.createElement('input');
            input.className = 'x-input';
            cell.appendChild(input);
            row.appendChild(cell);
            tablex.appendChild(row);
        }
        matrixContainer.appendChild(table);
        vectorContainer.appendChild(tablev);
        xContainer.appendChild(tablex);
    }

    function getMatrixValues() {
        const inputs = matrixContainer.getElementsByTagName('input');
        const matrix = [];
        for (let i = 0; i < matrixSize; i++) {
            const row = [];
            for (let j = 0; j < matrixSize; j++) {
                const index = i * matrixSize + j;
                row.push(inputs[index].value || '0'); // Default to 0 if empty
            }
            matrix.push(row);
        }
        return matrix;
    }

    function getVectorValues(){
        const inputs = vectorContainer.getElementsByTagName('input');
        const vector = [];
        for (let i = 0; i < matrixSize; i++) {
            const value = inputs[i].value || '0'; // Default to 0 if empty
            vector.push([value]); // Each value is a row in a single-column matrix
        }
        return vector;
    }

    function getXValues(){
        const inputs = xContainer.getElementsByTagName('input');
        const x = [];
        for (let i = 0; i < matrixSize; i++) {
            const value = inputs[i].value || '0'; // Default to 0 if empty
            x.push([value]); // Each value is a row in a single-column matrix
        }
        return x;
    }

    function formatMatrixForMATLAB(matrix) {
        let matlabFormat = '[';
        matrix.forEach((row, rowIndex) => {
            matlabFormat += row.join(' ');
            if (rowIndex < matrix.length - 1) {
                matlabFormat += '; ';
            }
        });
        matlabFormat += ']';
        
        return matlabFormat;
    }

    document.getElementById('increaseSize').addEventListener('click', function() {
        if (matrixSize < maxSize) {
            matrixSize++;
            matrixSizeDisplay.textContent = matrixSize;
            generateMatrixVector(matrixSize);
        }
    });

    document.getElementById('decreaseSize').addEventListener('click', function() {
        if (matrixSize > 1) {
            matrixSize--;
            matrixSizeDisplay.textContent = matrixSize;
            generateMatrixVector(matrixSize);
        }
    });

    document.getElementById('submitMatrix').addEventListener('click', function() {
        const matrix = getMatrixValues();
        const vector = getVectorValues();
        const x = getXValues();
        const matlabMatrix = formatMatrixForMATLAB(matrix);
        const matlabVector = formatMatrixForMATLAB(vector);
        const matlabX = formatMatrixForMATLAB(x);
        matrixDataInput.value = matlabMatrix;
        vectorDataInput.value = matlabVector;
        xDataInput.value = matlabX;
    });

    // Inicializar la matriz con el tamaño inicial
    generateMatrixVector(matrixSize);
});
