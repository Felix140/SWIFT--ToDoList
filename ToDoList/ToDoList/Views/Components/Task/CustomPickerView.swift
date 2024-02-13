import SwiftUI

struct CustomPickerView: View {
    @Binding var selectedPicker: Int
    let options = ["All Tasks", "To Do", "Done"]
    let underlineColor: Color = .blue
    @State private var underlineOffset: CGFloat = 0
    @State private var underlineWidth: CGFloat = 0

    var body: some View {
        GeometryReader { fullGeometry in
            ZStack(alignment: .bottomLeading) {
                HStack(alignment: .center, spacing: 20) {
                    ForEach(options.indices, id: \.self) { index in
                        Text(options[index])
                            .foregroundColor(self.selectedPicker == index ? underlineColor : .primary)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    self.selectedPicker = index
                                }
                            }
                    }
                }
                .frame(height: 40)
                .onAppear {
                    underlineWidth = fullGeometry.size.width / CGFloat(options.count) - (20 * CGFloat(options.count - 1) / CGFloat(options.count))
                    underlineOffset = calculateUnderlineOffset(fullGeometry: fullGeometry)
                }
                .onChange(of: selectedPicker) { _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        underlineOffset = calculateUnderlineOffset(fullGeometry: fullGeometry)
                    }
                }

                RoundedRectangle(cornerRadius: 2)
                    .fill(underlineColor)
                    .frame(width: underlineWidth, height: 4)
                    .offset(x: underlineOffset)
            }
            .frame(height: 50)
        }
        .frame(height: 50) // Assicura che la GeometryReader non espanda oltre il necessario
    }
    
    private func calculateUnderlineOffset(fullGeometry: GeometryProxy) -> CGFloat {
        let optionWidth = fullGeometry.size.width / CGFloat(options.count)
        let spacing = 20 * CGFloat(selectedPicker) // Ajust based on your spacing
        return optionWidth * CGFloat(selectedPicker) + spacing / CGFloat(options.count)
    }
}

struct CustomPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomPickerView(selectedPicker: .constant(0))
    }
}
