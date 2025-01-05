module ai

import arrays

// Neuron: unit dasar pemrosesan
pub struct Neuron {
pub mut:
    weights []f64  // bobot untuk setiap input
    bias    f64    // bias neuron
    output  f64    // hasil aktivasi
}

// Layer: kumpulan neuron
pub struct Layer {
pub mut:
    neurons []Neuron  // kumpulan neuron dalam layer
    size    int       // jumlah neuron
}

// Network: kumpulan layer yang terkoneksi
pub struct Network {
pub mut:
    layers []Layer    // kumpulan layer
    input_size  int   // jumlah input
    output_size int   // jumlah output
}

// Inisialisasi network berdasarkan dataset
pub fn (mut network Network) init(dataset Dataset) {
    network.input_size = dataset.features[0].len
    network.output_size = arrays.distinct(dataset.labels).len
    
    // Buat input layer
    mut input_layer := Layer{
        size: network.input_size
    }
    for _ in 0..network.input_size {
        input_layer.neurons << Neuron{}
    }
    
    // Buat output layer
    mut output_layer := Layer{
        size: network.output_size
    }
    for _ in 0..network.output_size {
        output_layer.neurons << Neuron{}
    }
    
    network.layers << input_layer
    network.layers << output_layer
}

pub fn (network Network) info() {
    println('${title}\nInformasi Network${reset}')
    println('Input size : ${network.input_size}')
    println('Output size: ${network.output_size}')
    println('${bold}Arsitektur${reset}')
    for i, layer in network.layers {
        match i {
            0 { println('Input layer : ${layer.size} neuron') }
            network.layers.len-1 { println('Output layer: ${layer.size} neuron') }
            else { println('Hidden layer: ${layer.size} neuron') }
        }
    }
}