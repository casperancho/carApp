const mysql = require("mysql");
var express = require("express");
var app = express();


const connection = mysql.createConnection( {
	host: "sql472.your-server.de",
	user: "alfa_admin_r",
	database: "alfadb",
	password: "T4UzTvQy5JaukBxy"
});

var readyJSON = {};

connection.connect(function(err){
	if (err){
		return console.error("Ошибка" + err.message);
	}
	else {
		console.log("Подключено к бд");
	}
});

connection.query('SELECT * FROM cars', function(error,result){
	if (error) throw error;
	readyJSON = convertToJSON(result);
	//console.log("result:", result);
});

function convertToJSON(result){
	var json = JSON.stringify(result);
	return json;
};

connection.end(function(err) {
  if (err) {
    return console.log("Ошибка: " + err.message);
  }
  console.log("Подключение закрыто");
});


app.get('/', function (req, res) {
  res.send(readyJSON);
});


app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});

/* "car_id":2,"car_name":"Крайслер 300 С 12м.","car_year":2009,"car_number":"978",
"car_karaoke":1,"car_owner":1,"car_color":"красный","car_groop":1,"car_is_activ":1,"car_is_change":1
*/
