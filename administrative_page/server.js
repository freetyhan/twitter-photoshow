const express = require('express');
let app = express(); // express app
// const path = require('path');
// const fs = require('fs');


// function logRequest(req, res, next){
// 	// console.log(`${new Date()}  ${req.ip} : ${req.method} ${req.path}`);
// 	next();
// }

// const host = 'localhost';
// const port = 3000;
// const clientApp = __dirname;

// app.use(express.json()) 						// to parse application/json
// app.use(express.urlencoded({ extended: true })) // to parse application/x-www-form-urlencoded
// app.use(logRequest);							// logging for debug

// // serve static files (client-side)
// app.use('/', express.static(clientApp, { extensions: ['html'] }));
// app.listen(port, () => {
// 	console.log(`${new Date()}  App Started. Listening on ${host}:${port}, serving ${clientApp}`);
// });

// MYsql connection ---------------------------------------------
// https://www.youtube.com/watch?v=hGZX_SA7lYg&ab_channel=codedamn
var mysql = require('mysql2'); // mysql2 used instead of mysql

var connection = mysql.createConnection({host: "137.184.230.178", user: "aks", password: "123", database: "photo_gallery"});
connection.connect(function(err) {
    if (err) throw err;
    console.log("Connected!");
});

app.get('/', function(req, res) {
    // about mysql: "SELECT * FROM tweets WHERE show AND label AND NOT sensored"
    connection.query("SELECT * FROM keywords", function(error, rows, fields) { // [todo] akshat not defined yet
        if(error) throw error;
        console.log("Successful query!");
        res.json(rows); // will post to the website localhost:1337
        // parse with your rows/fields 
    })
    // access table "username" for hashtag and handles 
    // access table "keywords" for keywords
})

// update initial configuration
app.get('/updateconfig/:id', (req, res) => {
    let newTransition = 1;
    let sql = `UPDATE configuration SET transition_effect = '${newTransition}' WHERE id = ${req.params.id}`
    let query = connection.query(sql, err => {
        if (err) {
            throw err
        }
        res.send('configuration added 1')
    })
})

app.listen('1337', () => {
    console.log('Server started on port 1337')
});