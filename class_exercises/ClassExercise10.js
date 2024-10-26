/*
BC2402 Class Exercise 10
Name: Tang Te Jie, Nicholas
Matric No: U2310817H
*/

show dbs
use "boxoffice2"

/* 10.1.1 */
db.boxofficeExtended.find({"genre":{$size:2}})


/* 10.1.2 */
db.boxofficeExtended.find({"meta.aired":2018})


/* 10.1.3 */
db.boxofficeExtended.find({ "meta.rating" : { $gt :  8, $lt : 10}})


/* 10.2.1 */
show dbs
use sports

db.teams.updateMany(
    {"title": "Nanyang United"},
    {$set:{"requiresTeam": true}},
    {upsert:true})
    
db.teams.updateMany(
    {"title": "Sengkang One"},
    {$set:{"requiresTeam": false}},
    {upsert: true})


/* 10.2.2 */
db.teams.updateMany(
    {"requiresTeam": true}, 
    {$set: {"minAmtPlayers": 0}}, 
    {upsert: true})

db.teams.find()


/* 10.2.3 */
db.teams.updateMany( 
    {"requiresTeam": true}
    {$inc: {"minAmtPlayers": 10}})
    
db.teams.find()


/* 10.3 */
show dbs
use analytics
db.persons.aggregate([
  {$match: {"dob.age": { $gt: 50 }}},
  {$group: {
      _id: "$gender",
      averageAge: { $avg: "$dob.age" },
      totalPersons: { $sum: 1 }}},
  {$sort: {totalPersons: -1}}
])