module ai

// Parameter training
pub struct TrainConfig {
pub mut:
    learning_rate f64
    epochs        int
    batch_size    int = 32
}

// Backpropagation untuk satu layer
fn (mut layer Layer) backprop(inputs []f64, gradients []f64, learning_rate f64) []f64 {
    // Debug print untuk melihat dimensi
    // println('Backprop debug:')
    // println('Input size: ${inputs.len}')
    // println('Gradients size: ${gradients.len}')
    // println('Neuron weights size: ${layer.neurons[0].weights.len}')
    
    // Inisialisasi prev_gradients dengan ukuran yang benar
    mut prev_gradients := []f64{len: layer.neurons[0].weights.len, init: 0.0}
    
    for i, mut neuron in layer.neurons {
        if i < gradients.len {  // Pastikan dalam range
            gradient := gradients[i]
            
            // Update weights dan propagasi error
            for j, input in inputs {
                if j < neuron.weights.len {  // Pastikan dalam range
                    prev_gradients[j] += gradient * neuron.weights[j]
                    neuron.weights[j] -= learning_rate * gradient * input
                }
            }
            neuron.bias -= learning_rate * gradient
        }
    }
    
    return prev_gradients
}


// Training dengan backpropagation lengkap
pub fn (mut network Network) train(dataset Dataset, learning_rate f64, epochs int) {
    println('\n${title}Training Network${reset}')
    println('Learning Rate: ${learning_rate}')
    println('Epochs: ${epochs}')
    
    for epoch in 0..epochs {
        mut epoch_loss := 0.0
        
        // Debug: print dataset size
        // println('\nDataset size: ${dataset.features.len}')
        
        for i in 0..dataset.features.len {
            inputs := dataset.features[i]
            target := dataset.labels[i]
            
            // Debug: print input dan target
            // println('\nSample ${i}:')
            // println('Input: ${inputs}')
            // println('Target: ${target}')
            
            // Forward pass dengan debug
            mut activations := [][]f64{}
            activations << inputs.clone()
            mut current := inputs.clone()
            
            // println('\nForward Pass:')
            for _, layer in network.layers {
                current = layer.forward(current)
                activations << current.clone()
                // println('Layer ${idx} output: ${current}')
            }
            
            // Debug: print gradients
            // println('\nGradients:')
            mut gradients := activations.last().map(it - target)
            // println('Initial gradients: ${gradients}')
            
            // Backpropagation dengan debug
            // println('\nBackpropagation:')
            for j := network.layers.len-1; j >= 0; j-- {
                // println('Layer ${j} before backprop:')
                // println('Activations: ${activations[j]}')
                // println('Gradients: ${gradients}')
                
                gradients = network.layers[j].backprop(
                    activations[j], 
                    gradients, 
                    learning_rate
                )
                
                // println('Layer ${j} after backprop:')
                // println('New gradients: ${gradients}')
            }
            
            epoch_loss += mse_loss(activations.last(), target)
        }
        
		if epoch % 10 == 0 {
        	println('Epoch ${epoch}: loss = ${epoch_loss / dataset.features.len}')
		}
    }
}
