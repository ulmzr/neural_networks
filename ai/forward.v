module ai

// Forward propagation untuk satu neuron
fn (neuron Neuron) forward(inputs []f64) f64 {
    mut sum := neuron.bias
    
    for i, weight in neuron.weights {
        sum += weight * inputs[i]
    }
    
    return activate(sum, .sigmoid)  // default menggunakan sigmoid
}

// Forward propagation untuk satu layer
fn (layer Layer) forward(inputs []f64) []f64 {
    mut outputs := []f64{cap: layer.size}
    
    for neuron in layer.neurons {
        outputs << neuron.forward(inputs)
    }
    
    return outputs
}

// Forward propagation untuk seluruh network
pub fn (network Network) forward(inputs []f64) []f64 {
    mut current_inputs := inputs.clone()
    
    for layer in network.layers {
        current_inputs = layer.forward(current_inputs)
    }
    
    return current_inputs  // output dari layer terakhir
}
