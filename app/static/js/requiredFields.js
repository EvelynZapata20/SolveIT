document.addEventListener("DOMContentLoaded", function() {
    // Selecciona todos los elementos <input> en la página
    const inputs = document.querySelectorAll('input');

    // Agrega el atributo 'required' a cada <input>
    inputs.forEach(input => {
        input.setAttribute('required', 'required');
    });
});