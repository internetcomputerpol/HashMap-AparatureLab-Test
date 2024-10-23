import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";

actor AparatureLabs {
                                                 /*    https://play.motoko.org/?tag=147190593    */
  // Zaczynamy indeksowanie obiektów od 1000
  stable var index : Nat = 1000;
  //
  stable var tablica : [(Nat, Personel)] = [];

// Typ Rekord do tworzenia pracowników AparatureLabs
  type Personel = {
    imie : Text;
    nazwisko : Text;
    stanowisko : Text;
  };
// Zmienna map typu HashMap<klucz,wartość> przypisana jest jej wartość wyniku działania funkcji fromIter
 // ta funkcja iteruje przez obiekty tablicy podanej w argumencie przyjmuje jeszcze 3 argumenty 
 // odpowiadające za początkowy rozmiar i typ porównywania wartości klucz<> wartość, oraz funkcje haszującą klucze 
  var map : HashMap.HashMap<Nat, Personel> = HashMap.fromIter(tablica.vals(), 32, Nat.equal, Hash.hash);


// Funkcja wpisywania wartości do Mapy jako argument przyjmuje zmienną typu Rekord Typ Personel
  public func put(personel: Personel): async Text {
    index += 1;                                      // Dzięki temu zawsze dodajemy nowa liczbę do obiektu
    map.put(index, personel);                        // wywołanie funkcji put z wartością w arg. klucz wartość
    return " Index for Person is " # Nat.toText(index);
  };

// Funkcja pobierająca dane z Mapy
  public func get(key: Nat): async Text {
    let personel = map.get(key);               // Sprawdzanie czy pesonel nie jest pusty
    switch (personel) {
      case (null) return "Nie znalazłem osoby";
      case (?personel) return personel.imie # " | " # personel.nazwisko # " | " # personel.stanowisko # " |";
    };
  };

  public func remove(key: Nat): async Text {
    let person = map.remove(key);
    switch (person) {
      case (null) return "Nie znalazłem osoby";
      // Ten ? odnosi się do 
     case (?personel) return personel.imie # " | " # personel.nazwisko # " | " # personel.stanowisko # " |";
    };
  };
// Testowo 
  public query func getAll(): async [(Nat, Personel)] {
    return Iter.toArray(map.entries());
  };

  /*                 Funkcja systemowa zapisująca HashMap do tablicy przed updatem   */
  system func preupgrade() {
    tablica := Iter.toArray(map.entries());
  };
/*                 Funkcja systemowa wczytująca po updacie hashMapę z tablicy   */
  system func postupgrade() {
    map := HashMap.fromIter(tablica.vals(), 32, Nat.equal, Hash.hash);
  };
};
