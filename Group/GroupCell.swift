import SwiftUI

struct GroupCell: View {
    
    let name: String
    let tasks: (todo: Int, inProgress: Int, done: Int)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(name)
                .font(.system(size: 18))
                .bold()
                .lineLimit(2)
            HStack(spacing: 4) {
                Image(systemName: "square")
                Text("\(tasks.todo)")
                    .padding(.trailing, 8)
                Image(systemName: "arrow.left.and.right.square")
                Text("\(tasks.inProgress)")
                    .padding(.trailing, 8)
                Image(systemName: "checkmark.square")
                Text("\(tasks.done)")
            }
            progressIndicator
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 6)
                .stroke(.black, lineWidth: 1)
                .foregroundStyle(.clear)
        )
    }
    
    private var progressIndicator: some View {
        RoundedRectangle(cornerRadius: 2)
            .stroke(.black, lineWidth: 1)
            .frame(height: 10)
            .overlay {
                GeometryReader { proxy in
                    HStack(spacing: 0) {
                        Spacer()
                        Rectangle()
                            .foregroundStyle(.gray)
                            .frame(width: proxy.size.width * Double(tasks.inProgress) / Double(totalTasks))
                        Rectangle()
                            .frame(width: proxy.size.width * Double(tasks.done) / Double(totalTasks))
                    }
                }
            }
    }
    
    private var totalTasks: Int {
        tasks.todo + tasks.inProgress + tasks.done
    }
}

#Preview {
    GroupCell(
        name: "Diplomka",
        tasks: (24, 32, 10)
    )
    .previewLayout(.sizeThatFits)
}
