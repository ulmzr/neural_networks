module ai

import math

// Mean Squared Error untuk single target
pub fn mse_loss(predictions []f64, target f64) f64 {
    mut sum_squared_error := 0.0
    
    // Hitung error untuk setiap output
    for pred in predictions {
        error := pred - target
        sum_squared_error += error * error
    }
    
    return sum_squared_error / predictions.len
}


// Cross Entropy Loss untuk klasifikasi
pub fn cross_entropy_loss(predictions []f64, targets []f64) f64 {
    mut sum := 0.0
    
    for i in 0..predictions.len {
        sum += targets[i] * math.log(predictions[i] + 1e-15)
    }
    
    return -sum / predictions.len
}

// Evaluasi dan tampilkan performa network
pub fn (network Network) evaluate(dataset Dataset) f64 {
    println('\n${title}Evaluasi Network${reset}')
    
    // Test prediksi sample pertama
    sample_input := dataset.features[0]
    predictions := network.forward(sample_input)
    
    println('Sample Input : ${sample_input}')
    println('Prediksi     : ${predictions}')
    println('Target       : ${dataset.labels[0]}')
    
    // Hitung rata-rata loss
    mut total_loss := 0.0
    for i in 0..dataset.features.len {
        pred := network.forward(dataset.features[i])
        total_loss += mse_loss(pred, dataset.labels[i])
    }
    avg_loss := total_loss / dataset.features.len
    
    println('Average Loss : ${avg_loss}')
    return avg_loss
}