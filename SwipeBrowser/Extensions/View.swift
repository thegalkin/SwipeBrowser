//
//  View.swift
//  SwipeBrowser
//
//  Created by Никита Галкин on 08.01.2022.
//

import SwiftUI

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    func getUIView () -> UIView {
        let uiView: UIView = UIHostingController.init(rootView: self.body).view
        return uiView
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

private struct EdgeBorder: Shape {
    
    var width: CGFloat
    var edges: [Edge]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                    case .top, .bottom, .leading: return rect.minX
                    case .trailing: return rect.maxX - width
                }
            }
            
            var y: CGFloat {
                switch edge {
                    case .top, .leading, .trailing: return rect.minY
                    case .bottom: return rect.maxY - width
                }
            }
            
            var w: CGFloat {
                switch edge {
                    case .top, .bottom: return rect.width
                    case .leading, .trailing: return self.width
                }
            }
            
            var h: CGFloat {
                switch edge {
                    case .top, .bottom: return self.width
                    case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
    }
