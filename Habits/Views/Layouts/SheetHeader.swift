//
//  SheetHeader.swift
//  Habits
//
//  Created by Andrey on 09/01/2026.
//

import SwiftUI

struct SheetHeader: View {
    
    // MARK: Properties
    
    @Environment(\.dismiss)
    private var dismiss
    
    private let habit: Habit
    
    private let emojiToTitleSpacing: CGFloat = 4
    private let emojiSize: CGFloat = 34
    private let emojiFrameSize: CGFloat = 38
    
    private let buttonHeight: CGFloat = 44
    private let buttonHorizontalPadding: CGFloat = 16
    
    // MARK: Initializers
    
    init(habit: Habit) {
        self.habit = habit
    }
    
    // MARK: Body
    
    var body: some View {
        HStack {
            titleSection()
            Spacer()
            button()
        }
    }
    
    // MARK: Subviews
    
    private func titleSection() -> some View {
        HStack(spacing: emojiToTitleSpacing) {
            Text(habit.emoji)
                .font(.system(size: emojiSize))
                .frame(width: emojiFrameSize, height: emojiFrameSize)
            
            Text(habit.title)
                .font(.title3.bold())
                .foregroundStyle(.labelVibrantPrimary)
        }
    }
    
    private func button() -> some View {
        Button {
            dismiss()
        } label: {
            Text("Done")
                .bold()
                .foregroundStyle(.white)
                .frame(height: buttonHeight)
                .padding(.horizontal, buttonHorizontalPadding)
                .background(.labelVibrantPrimary, in: .capsule)
        }
    }
}

#Preview {
    SheetHeader(habit: sampleHabit)
        .padding()
}
