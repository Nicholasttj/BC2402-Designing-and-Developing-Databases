/*
BC2402 Class Exercise 9
Name: Tang Te Jie, Nicholas
Matric No: U2310817H
*/

/* 9.1 */

db.moviestarts.findOne()


/* 9.2 */

db.moviestarts.find({
  rating: { $gt: 9.2 },
  runtime: { $lt: 100 }
})


/* 9.3 */
db.moviestarts.find({
  genre: { $in: ["drama", "action"] }
})


/* 9.4 */
db.moviestarts.find({
  genre: { $all: ["drama", "action"] }
})


/* 9.5 */
db.moviestarts.find({
  $expr: { $gt: ["$visitors", "$expectedVisitors"] }
})


/* 9.6 */
db.moviestarts.find({
  title: { $regex: /Su/, $options: "i" }
})


/* 9.7 */
db.moviestarts.find({
  $or: [
    { genre: { $all: ["action", "thriller"] } },
    { 
      genre: "drama",
      visitors: { $gt: 300000 },
      rating: { $gte: 8, $lte: 9.5 }
    }
  ]
})