module ai

import math
import math.stats

// Normalisasi dataset dengan metode yang dipilih
pub fn (mut dataset Dataset) normalize(method string) {
    dataset.normalize_type = method
    
    match method {
        'minmax' { dataset.normalize_minmax() }
        'zscore' { dataset.normalize_zscore() }
        'scaling' { dataset.normalize_robust() }
        'log' { dataset.normalize_log() }
        else { 
        println('${red}\nMetode normalisasi tidak dikenal${reset}')
        println('Metode yang tersedia:')
        println('- minmax  : Min-Max Scaling [0,1]')
        println('- zscore  : Z-Score Standardization')
        println('- scaling : Robust Scaling dengan median & IQR')
        println('- log     : Log Transformation')
    }
    }
}

// Normalisasi Min-Max ke range [0,1]
fn (mut dataset Dataset) normalize_minmax() {
    features_count := dataset.features[0].len
    dataset.feature_min = []f64{len: features_count}
    dataset.feature_max = []f64{len: features_count}
    
    for i in 0..features_count {
        mut column := []f64{}
        for row in dataset.features {
            column << row[i]
        }
        
        min, max := stats.minmax(column) 
        dataset.feature_min[i] = min
        dataset.feature_max[i] = max
        range := max - min
        
        for mut row in dataset.features {
            row[i] = (row[i] - min) / range
        }
    }
}

// Normalisasi Z-Score (Standardization)
fn (mut dataset Dataset) normalize_zscore() {
    features_count := dataset.features[0].len
    dataset.feature_mean = []f64{len: features_count}
    dataset.feature_std = []f64{len: features_count}
    
    for i in 0..features_count {
        mut column := []f64{}
        for row in dataset.features {
            column << row[i]
        }
        
        mean := stats.mean(column)
        std := stats.sample_stddev(column)
        dataset.feature_mean[i] = mean
        dataset.feature_std[i] = std
        
        for mut row in dataset.features {
            row[i] = (row[i] - mean) / std
        }
    }
}

// Normalisasi Robust Scaling menggunakan median dan IQR
fn (mut dataset Dataset) normalize_robust() {
    features_count := dataset.features[0].len
    dataset.feature_median = []f64{len: features_count}
    dataset.feature_max = []f64{len: features_count} // Untuk menyimpan IQR
    
    for i in 0..features_count {
        mut column := []f64{}
        for row in dataset.features {
            column << row[i]
        }
        
        median := stats.median(column)
        q1 := stats.quantile(column, 0.25) or { 0.0 }
        q3 := stats.quantile(column, 0.75) or { 1.0 }
        iqr := q3 - q1
        
        dataset.feature_median[i] = median
        dataset.feature_max[i] = iqr // Menggunakan feature_max untuk IQR
        
        for mut row in dataset.features {
            row[i] = (row[i] - median) / iqr
        }
    }
}

// Normalisasi Log (Natural logarithm)
fn (mut dataset Dataset) normalize_log() {
    features_count := dataset.features[0].len
    dataset.feature_min = []f64{len: features_count} // Menyimpan nilai minimum sebelum log
    
    for i in 0..features_count {
        mut min_val := f64(0.0)
        // Cari nilai minimum untuk shift jika ada nilai <= 0
        for row in dataset.features {
            if row[i] <= min_val {
                min_val = row[i] - 1.0 // Shift ke bawah
            }
        }
        dataset.feature_min[i] = min_val
        
        // Aplikasikan log transform
        for mut row in dataset.features {
            row[i] = math.log(row[i] - min_val)
        }
    }
}

// Denormalisasi dataset ke nilai asli
pub fn (mut dataset Dataset) denormalize() {
    features_count := dataset.features[0].len
    
    match dataset.normalize_type {
        'minmax' {
            for i in 0..features_count {
                range := dataset.feature_max[i] - dataset.feature_min[i]
                for mut row in dataset.features {
                    row[i] = (row[i] * range) + dataset.feature_min[i]
                }
            }
        }
        'zscore' {
            for i in 0..features_count {
                for mut row in dataset.features {
                    row[i] = (row[i] * dataset.feature_std[i]) + dataset.feature_mean[i]
                }
            }
        }
        'scaling' {
            for i in 0..features_count {
                iqr := dataset.feature_max[i] // IQR tersimpan di feature_max
                for mut row in dataset.features {
                    row[i] = (row[i] * iqr) + dataset.feature_median[i]
                }
            }
        }
        'log' {
            for i in 0..features_count {
                for mut row in dataset.features {
                    row[i] = math.exp(row[i]) + dataset.feature_min[i]
                }
            }
        }
        else {}
    }
    
    // Reset tipe normalisasi
    dataset.normalize_type = ''
}
