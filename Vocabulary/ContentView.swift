//
//  ContentView.swift
//  Vocabulary
//
//  Created by Quincy Jones on 7/28/23.
//

import SwiftUI
struct DictionaryEntry: Codable, Identifiable {
    var id = UUID() // Add an identifier for the list
    let term: String
    let definition: String
}

struct ContentView: View {
    @State private var randomWord: String = ""
    @State private var randomdefinition: String = ""
    @State private var savedWords: [DictionaryEntry] = []
    @State private var isSheetPresented = false
    
    var body: some View {
        ZStack(alignment: .center) {
            randomRadialGradient()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                
                    VStack(alignment: .center, spacing: 15){

                            Text(randomWord)
                                .padding()
                                .bold()
                                .onAppear{
                                    readJSONFromFile()
                                }
                            HStack{
//                                Text("adj").padding(.horizontal)
//                                Text("synonyms")
                            }.padding(.bottom)

                        Text(randomdefinition)
                            .padding()
                        HStack(alignment: .bottom){
                            Button(action: {
                                savedWords.append(DictionaryEntry(term: randomWord, definition: randomdefinition))
                            }, label: {
                                Image(systemName: "heart")
                                    .padding()
                                    .foregroundColor(.red)
                                    .background(.blue)
                                    .cornerRadius(25)
                            })
                            
                            Button(action: {
                                isSheetPresented = true
                            }, label: {
                                Image(systemName: "list.bullet")
                                    .padding()
                                    .foregroundColor(.black)
                                    .background(.blue)
                                    .cornerRadius(25)
                            })
                            Button(action: {
                                readJSONFromFile()
                            }, label: {
                                Image(systemName: "plus.circle.fill")
                                    .padding()
                                    .foregroundColor(.green)
                                    .background(.blue)
                                    .cornerRadius(25)
                            })
                        }
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .padding()

                

            }
        }
        .sheet(isPresented: $isSheetPresented, content: {
            NavigationView {
                List {
                    ForEach(savedWords) { entry in
                        NavigationLink(destination: DetailPage(term: entry.term, definition: entry.definition)) {
                            VStack(alignment: .leading) {
                                Text(entry.term)
                                    .font(.headline)
                            }
                        }
                    }
                    .onDelete(perform: deleteWord)
                }
                .navigationBarTitle("Saved Words")
            }

        })
    }
    func deleteWord(at offsets: IndexSet) {
        savedWords.remove(atOffsets: offsets)
    }

    func readJSONFromFile() {
        if let path = Bundle.main.path(forResource: "dictionary", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                parseJSON(data: data)
            } catch {
                print("Error reading data from file: \(error)")
            }
        }
    }

    func parseJSON(data: Data) {
        let decoder = JSONDecoder()
        do {
            let dictionary = try decoder.decode([String: String].self, from: data)
            
            // Convert dictionary keys to an array
            let keys = Array(dictionary.keys)
            
            // Choose a random word from the array
            if let randomTerm = keys.randomElement() {
                if let definition = dictionary[randomTerm] {
                    let entry = DictionaryEntry(term: randomTerm, definition: definition)
                    randomWord = entry.term
                    randomdefinition = entry.definition
                    
                    print("Term: \(entry.term)")
                    print("Definition: \(entry.definition)")
                } else {
                    print("Term not found in the JSON dictionary.")
                }
            } else {
                print("Dictionary is empty.")
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    
    func selectRandomWordFromFile() -> String {
        if let path = Bundle.main.path(forResource: "true", ofType: "txt") {
            do {
                let content = try String(contentsOfFile: path, encoding: .utf8)
                let wordsArray = content.components(separatedBy: .newlines)
                
                // Remove empty elements if any
                let cleanedWordsArray = wordsArray.filter { !$0.isEmpty }
                
                if let randomIndex = cleanedWordsArray.indices.randomElement() {
                    return cleanedWordsArray[randomIndex]
                }
            } catch {
                print("Error reading file: \(error)")
                return "error"
            }
        }
        return "none"
    }
    
    func removeFirstAndLastFiveCharacters(_ inputString: String) -> String {
        // Check if the string is at least 6 characters long
        if inputString.count >= 6 {
            // Get the index of the first character after removal
            let startIndex = inputString.index(inputString.startIndex, offsetBy: 2)
            
            // Get the index of the character before the last five characters
            let endIndex = inputString.index(inputString.endIndex, offsetBy: -4)
            
            // Create a new substring by removing the first character and the last five characters
            let result = inputString[startIndex..<endIndex]
            
            return String(result)
        } else {
            // Return the input string as is if it's shorter than 6 characters
            return inputString
        }
    }
    
}

struct DetailPage: View {
    let term: String
    let definition: String

    var body: some View {
        ZStack(alignment: .center) {
            randomRadialGradient()
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center){
                
                ScrollView{
                    VStack(alignment: .center, spacing: 15){

                            Text(term)
                                .padding()
                                .bold()
                            HStack{
                                //                                Text("adj").padding(.horizontal)
                                //  Text("synonyms")
                            }.padding(.bottom)
                        
                        Text(definition)
                    }
                    .padding(15)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .padding()
                    
                }
            }
        }
    }
}

func randomRadialGradient() -> RadialGradient {
    // Generate three random colors
    let color1 = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    let color2 = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    let color3 = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    
    // Create a radial gradient with the three random colors
    let gradient = RadialGradient(gradient: Gradient(colors: [color1, color2, color3]), center: .center, startRadius: 50, endRadius: 450)
    
    return gradient
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
