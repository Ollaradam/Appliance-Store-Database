var express = require('express');
var app = express();
app.use(express.json())
app.use(express.urlencoded({extended: true}))
PORT = 4120;

var db = require('./database/dbcon');

const { engine } = require ('express-handlebars');
var exphbs = require('express-handlebars');
app.engine('.hbs', engine({extname: ".hbs"}))
app.set('view engine', '.hbs');

app.get('/', function(req, res)
    {
        res.render('index');
    });

app.get('/appliances', function(req, res)
    {  
        let query1 = "SELECT * FROM appliances;";               // Define our query

        db.pool.query(query1, function(error, rows, fields){    // Execute the query

            res.render('appliances', {data: rows});                  // Render the index.hbs file, and also send the renderer
        })                                                      // an object where 'data' is equal to the 'rows' we
    });                                                         // received back from the query

app.post('/add-appliance-form', function(req, res){
    // Capture the incoming data and parse it back to a JS object
    let data = req.body;

    // Create the query and run it on the database
    query1 = `INSERT INTO appliances (brand, type, modelNum, serialNum) VALUES ('${data['input-brand']}', '${data['input-type']}', '${data['input-modelNum']}', '${data['input-serialNum']}')`;
    db.pool.query(query1, function(error, rows, fields){

        // Check to see if there was an error
        if (error) {

            // Log the error to the terminal so we know what went wrong, and send the visitor an HTTP response 400 indicating it was a bad request.
            console.log(error)
            res.sendStatus(400);
        }

        // If there was no error, we redirect back to our root route, which automatically runs the SELECT * FROM bsg_people and
        // presents it on the screen
        else
        {
            res.redirect('/appliances');
        }
    })
})

app.delete('/delete-appliance-ajax/', function(req,res,next){
    let data = req.body;
    let applianceID = parseInt(data.applianceID);
    let deleteAppliance = `DELETE FROM appliances WHERE applianceID = ?`;

    db.pool.query(deleteAppliance, [applianceID], function(error, rows, fields) {

        if (error) {
            console.log(error);
            res.sendStatus(400);
        } else {
            res.sendStatus(204);
        }
    })});

app.listen(PORT, function(){
    console.log('Express started on ' + PORT + ' press ctrl+C to terminate.')
})