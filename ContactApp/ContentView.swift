//
//  ContentView.swift
//  ContactApp
//
//  Created by User-UAM on 1/25/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var newName: String = ""  // Estado para el nombre del nuevo contacto
    @State private var newPhoneNumber: String = ""  // Estado para el número del nuevo contacto
    @State private var showWelcome = true  // Estado para controlar la vista de bienvenida
    @State private var selectedContact: Item?  // Estado para almacenar el contacto seleccionado

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>  // Datos de los contactos almacenados

    var body: some View {
        VStack(spacing: 5) {
            if showWelcome {
                // Muestra la vista de bienvenida al inicio
                WelcomeView(showWelcome: $showWelcome)
            } else {
                NavigationView {
                    VStack(spacing: 20) {
                        // Campos de texto para ingresar el nombre y teléfono
                        CustomTextField(placeholder: "Ingresa un nombre", text: $newName)
                        CustomTextField(placeholder: "Ingresa el número de celular", text: $newPhoneNumber, keyboardType: .phonePad)

                        List {
                            ForEach(items) { item in
                                Button(action: {
                                    selectedContact = item  // Selecciona un contacto para ver detalles
                                }) {
                                    ContactRow(item: item)  // Muestra cada contacto en una fila
                                }
                            }
                            .onDelete(perform: deleteItems)  // Permite eliminar contactos
                        }
                        .listStyle(PlainListStyle())  // Estilo de lista sin formato adicional
                        .background(Color.white)  // Fondo blanco para la lista
                        .toolbar {
                            // Elementos de la barra de herramientas
                            ToolbarItem(placement: .navigationBarLeading) {
                                Image("contactimage")  // Imagen en la barra de navegación
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 160, height: 160)
                                    .padding(.leading, 10)
                                    .padding(.top, 80)
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()  // Botón para editar la lista
                                    .padding(.top, 10)
                                    .foregroundColor(Color(red: 140/255, green: 149/255, blue: 105/255))
                            }
                            ToolbarItem {
                                Button(action: addItem) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.headline)
                                            .foregroundColor(Color(red: 140/255, green: 149/255, blue: 105/255))
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                        Text("Selecciona un contacto para ver info")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(red: 168/255, green: 89/255, blue: 82/255))
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(item: $selectedContact) { contact in
            VStack {
                Spacer()

                // Contenedor de tarjeta para los detalles del contacto seleccionado
                VStack(spacing: 10) {  // Espaciado entre los elementos dentro de la tarjeta
                    // Imagen en la parte superior de la tarjeta
                    Image("contactimage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .padding(.bottom, 5)

                    Text("Contacto")
                        .font(.system(size: 28, weight: .heavy))  // Título "Contacto" en la tarjeta
                        .foregroundColor(Color(red: 140/255, green: 149/255, blue: 105/255))
                        .padding(.top, 0)
                        .padding(.bottom, 0)

                    // Información del contacto: nombre
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Nombre")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 47/255, green: 37/255, blue: 34/255))
                            Text(contact.name ?? "Sin nombre")
                                .font(.title2)
                                .foregroundColor(Color(red: 47/255, green: 37/255, blue: 34/255))
                                .fontWeight(.bold)
                        }
                    }

                    // Información del contacto: teléfono
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Teléfono")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 47/255, green: 37/255, blue: 34/255))
                            Text(contact.phoneNumber ?? "Sin número")
                                .font(.title2)
                                .foregroundColor(Color(red: 47/255, green: 37/255, blue: 34/255))
                                .fontWeight(.bold)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(RoundedRectangle(cornerRadius: 30).fill(Color.white))  // Fondo blanco para la tarjeta
                .shadow(radius: 15)
                .padding(.horizontal)
                
                Spacer()
            }
            .frame(height: UIScreen.main.bounds.height / 2 + 40)  // Ajuste de la altura de la tarjeta
        }
    }

    // Función para agregar un nuevo contacto
    private func addItem() {
        guard !newName.isEmpty, !newPhoneNumber.isEmpty else { return }

        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.name = newName
            newItem.phoneNumber = newPhoneNumber

            do {
                try viewContext.save()  // Guarda el nuevo contacto en CoreData
                newName = ""
                newPhoneNumber = ""
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // Función para eliminar un contacto
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()  // Guarda los cambios después de la eliminación
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            .keyboardType(keyboardType)
            .padding(.horizontal)
            .shadow(radius: 5)
    }
}

struct ContactRow: View {
    var item: Item

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name ?? "Sin nombre")
                    .font(.headline)
                    .foregroundColor(Color(red: 47/255, green: 37/255, blue: 34/255))
                Text(item.phoneNumber ?? "Sin número")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 70/255, green: 60/255, blue: 55/255))
            }
            Spacer()
            Image(systemName: "person.circle.fill")
                .foregroundColor(Color(red: 47/255, green: 37/255, blue: 34/255))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))  // Fondo blanco con esquinas redondeadas
        .shadow(radius: 5)  // Sombra más suave
    }
}
