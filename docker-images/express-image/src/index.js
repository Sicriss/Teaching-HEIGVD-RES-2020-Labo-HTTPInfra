var Chance = require("chance");
var chance = new Chance();

var Express = require("express");
var app = Express();

app.use(function(req, res, next) 
{
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
});


app.get('/', function(req, res)
{
    res.send("Hello RES\n");
});


app.get('/animals', function(req, res)
{
    res.send(getRandomAnimals());
});


app.listen(3000, function() 
{
    console.log("Accepting HTTP requests on port 3000.");
});

function getRandomAnimals()
{
    var numberOfAnimals = chance.integer({min : 1, max : 20});

    var animals = [];

    for (var i = 0; i < numberOfAnimals; ++i)
    {
        animals.push({animal : chance.animal(), quantity : chance.integer({min : 1, max : 12})});
    }

    console.log("About to return some animals o/");
    return animals;
}
