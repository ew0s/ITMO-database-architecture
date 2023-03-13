db.auth_data.insertOne({
    id: 1,
});

db.customers.insertOne({
    id: 1,
    name: "John",
    surname: "Doe",
    experience: 1,
    age: 20,
    dr_license: "1234567",
    passport: "AB1234567",
    phone: "+79675535687"
});

db.orders.insertOne({
    id: 1,
    customer_id: 1,
    car_id: 1,
    created_at: "2022-01-01 15:32",
    rent_from: "2022-01-02 11:00",
    rent_to: "2022-01-03 19:00",
    status: 1,
    notes: ""
});

db.cars.insertOne({
    id: 1,
    rent_conditions: {
        min_age: 18,
        min_experience: 0,
        deposit: 100,
        max_day_mileage: 300
    },
    price: {
        period_from: 1,
        period_to: 3,
        price: 50,
    },
    manufacturer: "hyundai",
    model: "solaris",
    manufacture_year: 2019,
    engine_power: 123,
    transmission: 1,
    doors: 4,
    passenger_capacity: 4,
    description: "some description"
});

db.cars.createIndex({"price.period_from":1}, {background: true})

db.createView( "order_cars", "orders", [
   {
      $lookup:
         {
            from: "cars",
            localField: "car_id",
            foreignField: "id",
            as: "car"
         }
   },
])