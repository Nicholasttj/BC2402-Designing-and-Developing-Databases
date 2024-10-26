/*
BC2402 Class Exercise 8
Name: Tang Te Jie, Nicholas
Matric No: U2310817H
*/


/* 8.1 */

use simpleClinic


/* 8.2 */

use simpleClinic

db.patients.insertOne({
    firstname: "Ben",
    lastname: "Choi",
    age: 18,
    history:[
        {disease: "cold", treatment: "pain killer"},
        {checkup: "annual", output: "OK"},
        {disease: "sore throat", treatment: "antibodies"}
    ]
})

/* 8.3 */

db.patients.insertOne({
    firstname: "Jayden",
    lastname: "Choi",
    age: 35,
    history: [
        { disease: "cold", treatment: "pain killer" },
        { checkup: "blood pressure", output: "normal" },
        { disease: "mild asthma", treatment: "inhaler" }
    ]
});


db.patients.insertOne({
    firstname: "Cammy",
    lastname: "Soh",
    age: 29,
    history: [
        { disease: "stomach ache", treatment: "antacids" },
        { checkup: "cholesterol", output: "borderline" },
        { disease: "flu", treatment: "flu medication"}
    ]
});


db.patients.insertOne({
    firstname: "Mason",
    lastname: "Greenwood",
    age: 45,
    history: [
        { disease: "back pain", treatment: "physical therapy" },
        { checkup: "diabetes", output: "pre-diabetic" },
        { disease: "migraine", treatment: "pain relief medication" }
    ]
});


/* 8.4 */

db.patients.find()


/* 8.5 */

db.patients.find({ age: { $gt: 30 } })  


/* 8.6 */

db.patients.deleteMany({ "history.disease": "flu" })