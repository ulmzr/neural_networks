module ai

// Konfigurasi untuk Progressive Network Growth
pub struct PNGConfig {
pub mut:
    min_layers     int     = 1    // jumlah minimal hidden layer
    max_layers     int     = 5    // jumlah maksimal hidden layer
	base_neurons   int     = 8    // jumlah neuron awal
	growth_factor  int     = 2    // faktor pertumbuhan neuron
    growth_rate    f64     = 0.01 // tingkat pertumbuhan akurasi yang diharapkan
}

// Menambahkan method grow pada Network
pub fn (mut network Network) grow() {
    config := PNGConfig{}
    current_layers := network.layers.len - 2  
    
    if current_layers >= config.max_layers {
        return
    }
    
    // Hitung jumlah neuron untuk layer baru
    neurons_count := config.base_neurons * (config.growth_factor ^ current_layers)
    
    // Buat hidden layer baru
    mut new_layer := Layer{
        size: neurons_count
    }
    for _ in 0..neurons_count {
        new_layer.neurons << Neuron{}
    }
    
    // Sisipkan sebelum output layer
    network.layers.insert(network.layers.len-1, new_layer)
}
