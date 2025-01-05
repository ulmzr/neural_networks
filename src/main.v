module main

import ai 

fn main() {
    mut dataset := ai.load_dataset('data/sample.csv') or {
        panic('Error loading dataset: $err')
    }
    dataset.info()
    dataset.normalize('minmax')
    mut network := ai.Network{}
    network.init(dataset)
    network.grow()
    network.info()
    network.evaluate(dataset)
    network.optimize(dataset)
}


