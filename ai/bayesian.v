module ai
import math
import rand

// Konfigurasi Bayesian Optimizer
pub struct BayesianConfig {
pub mut:
    min_lr      f64 = 0.0001  
    max_lr      f64 = 0.1    
    min_epochs  int = 100    
    max_epochs  int = 1000   
    n_trials    int = 10     
    target_loss f64 = 0.025  
}

// Parameter hasil optimasi
pub struct OptimalParams {
pub mut:
    learning_rate f64
    epochs        int
    best_loss     f64
}

// Bayesian Optimization untuk mencari parameter optimal
pub fn (mut network Network) optimize(dataset Dataset) OptimalParams {
    config := BayesianConfig{}
    mut best_params := OptimalParams{
        learning_rate: config.min_lr
        epochs: config.min_epochs
        best_loss: 1e9
    }
    
    mut used_lr := map[f64]bool{}
    
    for trial in 0..config.n_trials {
        println('\n${title}Trial ${trial + 1}/${config.n_trials}${reset}')
        
        mut lr := 0.0
        for {
            lr = config.min_lr * math.pow(10, rand.f64() * 3)
            if !used_lr[lr] { break }
        }
        used_lr[lr] = true
        
        range := config.max_epochs - config.min_epochs
        epochs := config.min_epochs + rand.int_in_range(0, range) or { 0 }
        
        println('Current LR: ${lr}')
        println('Current Epochs: ${epochs}')
        
        network.train(dataset, lr, epochs)
        loss := network.evaluate(dataset)
        
        println('Current Loss: ${loss}')
        println('Best Loss so far: ${best_params.best_loss}')
        
        if loss < best_params.best_loss {
            best_params.learning_rate = lr
            best_params.epochs = epochs
            best_params.best_loss = loss
        }
        
        if loss <= config.target_loss {
            break
        }
    }
    
    println('\n${title}Hasil Optimasi${reset}')
    println('Learning Rate Optimal: ${best_params.learning_rate}')
    println('Epochs Optimal: ${best_params.epochs}')
    println('Loss Terbaik: ${best_params.best_loss}')
    
    return best_params
}
