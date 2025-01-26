//
//  WelcomeView.swift
//  ContactApp
//
//  Created by User-UAM on 1/25/25.
//

import Foundation
import SwiftUI

// Vista de bienvenida al iniciar la aplicación
struct WelcomeView: View {
    @Binding var showWelcome: Bool  // Controla la visibilidad de la vista de bienvenida

    var body: some View {
        VStack(spacing: 5) {
            // Imagen de bienvenida
            Image("welcomeImage")  // Nombre de la imagen en los Assets
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
                .padding(.top, -65)

            // Título "Bienvenido"
            Text("Bienvenido")
                .font(.system(size: 34, weight: .heavy))
                .foregroundColor(Color(red: 138/255, green: 160/255, blue: 105/255))
                .padding(.top, -70)

            // Subtítulo
            Text("A tus contactos")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(red: 46/255, green: 36/255, blue: 35/255))
                .padding(.top, -35)
                .padding(.bottom, 5)

            // Descripción
            Text("Esta aplicación te permite guardar y organizar tus contactos de manera fácil y rápida.")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(Color(red: 46/255, green: 36/255, blue: 35/255))
                .padding(.horizontal, 20)

            // Botón para continuar
            Button(action: {
                showWelcome = false  // Oculta la vista de bienvenida al presionar
            }) {
                Text("Ok, comencemos")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 181/255, green: 94/255, blue: 87/255))
                    .foregroundColor(Color(red: 239/255, green: 230/255, blue: 222/255))
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 50)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
    }
}
