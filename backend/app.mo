import Debug "mo:base/Debug";
import Float "mo:base/Float";
import Int "mo:base/Int";

actor BeratBadanIdeal {
    
    // Tipe data untuk jenis kelamin
    public type Gender = {
        #Pria;
        #Wanita;
    };
    
    // Tipe data untuk hasil perhitungan
    public type HasilPerhitungan = {
        metodeBroca: Float;
        metodeBMI: Float;
        metodeRobinson: Float;
        metodeDevine: Float;
        kategoriIMT: Text;
    };
    
    // Fungsi untuk menghitung berat badan ideal menggunakan rumus Broca
    public func hitungBrocca(tinggi: Float, gender: Gender): async Float {
        let tinggicm = tinggi;
        
        if (tinggicm < 160) {
            return (tinggicm - 100) - ((tinggicm - 100) * 0.1);
        } else {
            return (tinggicm - 100) - ((tinggicm - 100) * 0.15);
        };
    };
    
    // Fungsi untuk menghitung BMI (Body Mass Index)
    public func hitungBMI(berat: Float, tinggi: Float): async Float {
        let tinggiMeter = tinggi / 100;
        return berat / (tinggiMeter * tinggiMeter);
    };
    
    // Fungsi untuk menghitung berat badan ideal berdasarkan BMI normal (22)
    public func hitungBeratIdealBMI(tinggi: Float): async Float {
        let tinggiMeter = tinggi / 100;
        return 22 * (tinggiMeter * tinggiMeter);
    };
    
    // Fungsi untuk menghitung berat badan ideal menggunakan rumus Robinson
    public func hitungRobinson(tinggi: Float, gender: Gender): async Float {
        let tinggicm = tinggi;
        
        switch (gender) {
            case (#Pria) {
                return 52 + (1.9 * ((tinggicm - 152.4) / 2.54));
            };
            case (#Wanita) {
                return 49 + (1.7 * ((tinggicm - 152.4) / 2.54));
            };
        };
    };
    
    // Fungsi untuk menghitung berat badan ideal menggunakan rumus Devine
    public func hitungDevine(tinggi: Float, gender: Gender): async Float {
        let tinggicm = tinggi;
        
        switch (gender) {
            case (#Pria) {
                return 50 + (2.3 * ((tinggicm - 152.4) / 2.54));
            };
            case (#Wanita) {
                return 45.5 + (2.3 * ((tinggicm - 152.4) / 2.54));
            };
        };
    };
    
    // Fungsi untuk menentukan kategori berdasarkan BMI
    public func kategoriIMT(bmi: Float): async Text {
        if (bmi < 18.5) {
            return "Underweight (Kekurangan berat badan)";
        } else if (bmi >= 18.5 and bmi < 25) {
            return "Normal";
        } else if (bmi >= 25 and bmi < 30) {
            return "Overweight (Kelebihan berat badan)";
        } else if (bmi >= 30 and bmi < 35) {
            return "Obese I (Obesitas tingkat 1)";
        } else if (bmi >= 35 and bmi < 40) {
            return "Obese II (Obesitas tingkat 2)";
        } else {
            return "Obese III (Obesitas tingkat 3)";
        };
    };
    
    // Fungsi utama untuk menghitung semua metode sekaligus
    public func hitungSemuaMetode(tinggi: Float, beratSekarang: Float, gender: Gender): async HasilPerhitungan {
        let broca = await hitungBrocca(tinggi, gender);
        let bmiIdeal = await hitungBeratIdealBMI(tinggi);
        let robinson = await hitungRobinson(tinggi, gender);
        let devine = await hitungDevine(tinggi, gender);
        
        let bmiSekarang = await hitungBMI(beratSekarang, tinggi);
        let kategori = await kategoriIMT(bmiSekarang);
        
        return {
            metodeBroca = broca;
            metodeBMI = bmiIdeal;
            metodeRobinson = robinson;
            metodeDevine = devine;
            kategoriIMT = kategori;
        };
    };
    
    // Fungsi untuk memberikan rekomendasi
    public func berikanRekomendasi(beratSekarang: Float, beratIdeal: Float): async Text {
        let selisih = beratSekarang - beratIdeal;
        
        if (Float.abs(selisih) <= 2) {
            return "Berat badan Anda sudah ideal! Pertahankan dengan pola makan sehat dan olahraga teratur.";
        } else         if (selisih > 2) {
            return "Berat badan Anda " # Float.toText(selisih) # " kg di atas ideal. Disarankan untuk mengurangi berat badan dengan diet sehat dan olahraga.";
        } else {
            return "Berat badan Anda " # Float.toText(Float.abs(selisih)) # " kg di bawah ideal. Disarankan untuk menambah berat badan dengan pola makan bergizi.";
        };
    };
    
    // Fungsi untuk menampilkan hasil lengkap
    public func analisisLengkap(tinggi: Float, beratSekarang: Float, gender: Gender): async Text {
        let hasil = await hitungSemuaMetode(tinggi, beratSekarang, gender);
        let bmiSekarang = await hitungBMI(beratSekarang, tinggi);
        
        // Menggunakan rata-rata dari semua metode sebagai berat ideal
        let rataRataIdeal = (hasil.metodeBroca + hasil.metodeBMI + hasil.metodeRobinson + hasil.metodeDevine) / 4;
        let rekomendasi = await berikanRekomendasi(beratSekarang, rataRataIdeal);
        
        return "=== HASIL ANALISIS BERAT BADAN IDEAL ===" #
               "\n\nTinggi badan: " # Float.toText(tinggi) # " cm" #
               "\nBerat badan saat ini: " # Float.toText(beratSekarang) # " kg" #
               "\nBMI saat ini: " # Float.toText(bmiSekarang) #
               "\nKategori: " # hasil.kategoriIMT #
               "\n\n=== BERAT BADAN IDEAL MENURUT BERBAGAI METODE ===" #
               "\n• Metode Broca: " # Float.toText(hasil.metodeBroca) # " kg" #
               "\n• Metode BMI (BMI=22): " # Float.toText(hasil.metodeBMI) # " kg" #
               "\n• Metode Robinson: " # Float.toText(hasil.metodeRobinson) # " kg" #
               "\n• Metode Devine: " # Float.toText(hasil.metodeDevine) # " kg" #
               "\n• Rata-rata: " # Float.toText(rataRataIdeal) # " kg" #
               "\n\n=== REKOMENDASI ===" #
               "\n" # rekomendasi;
    };
    
    // Fungsi untuk menghitung kebutuhan kalori harian (BMR)
    public func hitungBMR(tinggi: Float, berat: Float, umur: Int, gender: Gender): async Float {
        let umurFloat = Float.fromInt(umur);
        switch (gender) {
            case (#Pria) {
                return 88.362 + (13.397 * berat) + (4.799 * tinggi) - (5.677 * umurFloat);
            };
            case (#Wanita) {
                return 447.593 + (9.247 * berat) + (3.098 * tinggi) - (4.330 * umurFloat);
            };
        };
    };
}