
function deleteAppliance(applianceID) {
    let link = '/delete-appliance-ajax/';
    let data = {
      applianceID: applianceID
    };
  
    $.ajax({
      url: link,
      type: 'DELETE',
      data: JSON.stringify(data),
      contentType: "application/json; charset=utf-8",
      success: function(result) {
        deleteRow(applianceID);
      }
    });
  }
  
  function deleteRow(applianceID){
      let table = document.getElementById("appliance-table");
      for (let i = 0, row; row = table.rows[i]; i++) {
         if (table.rows[i].getAttribute("data-value") == applianceID) {
              table.deleteRow(i);
              break;
         }
      }
  }