//ISSUES SOMEWHERE IN THIS CODE DOESNT WORK CORRECTLY

let addApplianceForm = document.getElementById('add-appliance-form');

// Modify the objects we need
addApplianceForm.addEventListener("submit", function (e) {
    
    // Prevent the form from submitting
    e.preventDefault();

    // Get form fields we need to get data from
    let inputBrand = document.getElementById("input-brand");
    let inputType = document.getElementById("input-type");
    let inputModelNum = document.getElementById("input-modelNum");
    let inputSerialNum = document.getElementById("input-serialNum");

    // Get the values from the form fields
    let brandValue = inputBrand.value;
    let typeValue = inputType.value;
    let modelNumValue = inputModelNum.value;
    let serialNumValue = inputSerialNum.value;

    // Put our data we want to send in a javascript object
    let data = {
        brand: brandValue,
        type: typeValue,
        modelNum: modelNumValue,
        serialNum: serialNumValue
    }
    
    // Setup our AJAX request
    var xhttp = new XMLHttpRequest();
    xhttp.open("POST", "/add-appliance-ajax", true);
    xhttp.setRequestHeader("Content-type", "application/json");

    // Tell our AJAX request how to resolve
    xhttp.onreadystatechange = () => {
        if (xhttp.readyState == 4 && xhttp.status == 200) {

            // Add the new data to the table
            addRowToTable(xhttp.response);

            // Clear the input fields for another transaction
            inputBrand.value = '';
            inputType.value = '';
            inputModelNum.value = '';
            inputSerialNum.value = '';
        }
        else if (xhttp.readyState == 4 && xhttp.status != 200) {
            console.log("There was an error with the input.")
        }
    }

    // Send the request and wait for the response
    xhttp.send(JSON.stringify(data));

})


// Creates a single row from an Object representing a single record from 
// bsg_people
addRowToTable = (data) => {

    // Get a reference to the current table on the page and clear it out.
    let currentTable = document.getElementById("appliance-table");

    // Get the location where we should insert the new row (end of table)
    let newRowIndex = currentTable.rows.length;

    // Get a reference to the new row from the database query (last object)
    let parsedData = JSON.parse(data);
    let newRow = parsedData[parsedData.length - 1]

    // Create a row and 4 cells
    let row = document.createElement("TR");
    let applianceIDCell = document.createElement("TD");
    let brandCell = document.createElement("TD");
    let typeCell = document.createElement("TD");
    let modelNumCell = document.createElement("TD");
    let serialNumCell = document.createElement("TD");

    let deleteCell = document.createElement("TD");

    // Fill the cells with correct data
    applianceIDCell.innerText = newRow.applianceID;
    brandCell.innerText = newRow.brand;
    typeCell.innerText = newRow.type;
    modelNumCell.innerText = newRow.modelNum;
    serialNumCell.innerText = newRow.serialNum;

    deleteCell = document.createElement("button");
    deleteCell.innerHTML = "Delete";
    deleteCell.onclick = function(){
    deleteAppliance(newRow.applianceID);
    };


    // Add the cells to the row
    row.appendChild(applianceIDCell);
    row.appendChild(brandCell);
    row.appendChild(typeCell);
    row.appendChild(modelNumCell);
    row.appendChild(serialNumCell);
    row.appendChild(deleteCell);

    // Add a row attribute so the deleteRow function can find a newly added row
    row.setAttribute('data-value', newRow.applianceID);

    // Add the row to the table
    currentTable.appendChild(row);
}