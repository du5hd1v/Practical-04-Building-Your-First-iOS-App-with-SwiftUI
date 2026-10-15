import SwiftUI

struct StudentDetailView: View {
    let student: Student
    @State private var animatedProgress: CGFloat = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Header Card (Section 18 & 27 Requirements)
                VStack(spacing: 16) {
                    // Required SF Symbol
                    Image(systemName: student.passed ? "person.crop.circle.badge.checkmark" : "person.crop.circle.badge.xmark")
                        .font(.system(size: 80))
                        .foregroundStyle(student.passed ? AppTheme.brandEmerald : AppTheme.brandCoral)
                        .padding(.top, 12)

                    // Student Name
                    Text(student.name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.primary)

                    // Mark Display
                    Text("Mark: \(student.mark)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    // Pass / Fail Result
                    Text(student.passed ? "PASS" : "FAIL")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundStyle(student.passed ? AppTheme.brandEmerald : AppTheme.brandCoral)

                    // Section 30 Additional Challenge: Grade
                    HStack(spacing: 6) {
                        Image(systemName: student.tierIcon)
                        Text("Grade: \(student.grade) (\(student.tierTitle))")
                            .fontWeight(.bold)
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(student.accentColor.opacity(0.14))
                    .foregroundStyle(student.accentColor)
                    .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .modernCard(cornerRadius: 22)

                // Creative Visual Score Gauge & Breakdown Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Performance Details")
                        .font(.headline)

                    HStack(spacing: 20) {
                        // Animated Circular Gauge
                        ZStack {
                            Circle()
                                .stroke(Color.primary.opacity(0.08), lineWidth: 10)
                                .frame(width: 80, height: 80)

                            Circle()
                                .trim(from: 0, to: animatedProgress)
                                .stroke(student.accentGradient, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .frame(width: 80, height: 80)

                            Text("\(student.mark)%")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("GPA Value:")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(String(format: "%.1f / 4.0", student.gpa))
                                    .fontWeight(.bold)
                            }
                            Divider()
                            HStack {
                                Text("Requirement:")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text(student.passed ? "Met (≥ 50)" : "Unmet (< 50)")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(student.passed ? AppTheme.brandEmerald : AppTheme.brandCoral)
                            }
                        }
                        .font(.subheadline)
                    }

                    // Score Spectrum Bar
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Score Spectrum")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [.red, .orange, .yellow, .green],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(height: 8)

                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 16, height: 16)
                                    .shadow(radius: 2)
                                    .overlay(Circle().stroke(student.accentColor, lineWidth: 2))
                                    .offset(x: max(0, min(geo.size.width - 16, (geo.size.width - 16) * (CGFloat(student.mark) / 100.0))))
                            }
                        }
                        .frame(height: 16)
                    }
                }
                .padding(18)
                .modernCard(cornerRadius: 18)

                Spacer(minLength: 20)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Student Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = CGFloat(student.mark) / 100.0
            }
        }
    }
}

#Preview {
    NavigationStack {
        StudentDetailView(student: Student(name: "Amal", mark: 72))
    }
}
