var mysql = require('mysql')

var pool = mysql.createPool({
    connectionLimit : 10,
    host : 'classmysql.engr.oregonstate.edu',
    user : 'cs340_ollara',
    password : '2878',
    database: 'cs340_ollara'
})

module.exports.pool = pool;