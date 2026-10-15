import SwiftUI

struct ContentView: View {
    @State private var students: [Student] = [
        Student(name: "Amal", mark: 72),
        Student(name: "Nimali", mark: 45),
        Student(name: "Ruwan", mark: 58)
    ]

    @State private var studentName: String = ""
    @State private var markText: String = ""
    @State private var errorMessage: String? = nil
    @State private var selectedFilter: RecordFilter = .all
    @State private var searchText: String = ""
    @State private var isAddExpanded: Bool = true

    enum RecordFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case passed = "Passed"
        case failed = "Failed"

        var id: String { rawValue }
    }

    // MARK: - Required Calculations
    var passedCount: Int {
        students.filter { $0.passed }.count
    }

    var failedCount: Int {
        students.count - passedCount
    }

    var averageScore: Double {
        guard !students.isEmpty else { return 0 }
        let sum = students.reduce(0) { $0 + $1.mark }
        return Double(sum) / Double(students.count)
    }

    // Live preview for typed mark
    var liveMarkPreview: (grade: String, tier: String, color: Color)? {
        guard let mark = Int(markText.trimmingCharacters(in: .whitespacesAndNewlines)),
              mark >= 0 && mark <= 100 else { return nil }
        let temp = Student(name: "Temp", mark: mark)
        return (temp.grade, temp.tierTitle, temp.accentColor)
    }

    var filteredStudents: [Student] {
        students.filter { student in
            let matchesFilter: Bool
            switch selectedFilter {
            case .all:
                matchesFilter = true
            case .passed:
                matchesFilter = student.passed
            case .failed:
                matchesFilter = !student.passed
            }

            if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return matchesFilter
            } else {
                return matchesFilter && student.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Analytics Summary Cards
                    analyticsSection

                    // Passed Student Count Banner (Explicit Practical Requirement)
                    passedBanner

                    // Input Form Card (Part C & D)
                    inputCard

                    // Filter & Search Controls
                    filterControls

                    // Students List (Part E)
                    studentsListSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)
                .padding(.bottom, 30)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("SE4041 Marks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .shadow(color: AppTheme.brandIndigo.opacity(0.3), radius: 4, x: 0, y: 2)
                }
            }
        }
    }

    // MARK: - Subviews

    private var analyticsSection: some View {
        HStack(spacing: 12) {
            statCard(title: "Passed", value: "\(passedCount)", icon: "checkmark.seal.fill", color: AppTheme.brandEmerald)
            statCard(title: "Failed", value: "\(failedCount)", icon: "xmark.seal.fill", color: AppTheme.brandCoral)
            statCard(title: "Average", value: String(format: "%.1f", averageScore), icon: "chart.bar.xaxis", color: AppTheme.brandCyan)
            statCard(title: "Total", value: "\(students.count)", icon: "person.3.fill", color: AppTheme.brandIndigo)
        }
    }

    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
                Spacer()
            }

            Text(value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)

            Text(title)
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .modernCard(cornerRadius: 14)
    }

    private var passedBanner: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(AppTheme.brandEmerald)
                Text("Passed Students: \(passedCount)")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }

            Spacer()

            Text("Pass mark: 50")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .modernCard(cornerRadius: 14)
    }

    private var inputCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    isAddExpanded.toggle()
                }
            }) {
                HStack {
                    Label("Add Student", systemImage: "person.crop.circle.badge.plus")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Spacer()

                    Image(systemName: isAddExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppTheme.brandIndigo)
                }
            }
            .buttonStyle(.plain)

            if isAddExpanded {
                VStack(spacing: 12) {
                    // Student Name Field
                    HStack(spacing: 10) {
                        Image(systemName: "person.fill")
                            .foregroundStyle(AppTheme.brandIndigo)
                            .frame(width: 20)

                        TextField("Student Name", text: $studentName)
                            .autocorrectionDisabled()

                        if !studentName.isEmpty {
                            Button(action: { studentName = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.tertiarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    // Mark Field
                    HStack(spacing: 10) {
                        Image(systemName: "number.square.fill")
                            .foregroundStyle(AppTheme.brandCyan)
                            .frame(width: 20)

                        TextField("Mark", text: $markText)
                            .keyboardType(.numberPad)

                        if let preview = liveMarkPreview {
                            HStack(spacing: 4) {
                                Text(preview.grade)
                                    .fontWeight(.bold)
                                Text("· \(preview.tier)")
                            }
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(preview.color.opacity(0.15))
                            .foregroundStyle(preview.color)
                            .clipShape(Capsule())
                        }

                        if !markText.isEmpty {
                            Button(action: { markText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.tertiarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                    // Preset Chips
                    HStack(spacing: 8) {
                        Text("Presets:")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        presetButton("0 (Min)", value: "0")
                        presetButton("50 (Pass)", value: "50")
                        presetButton("75 (Merit)", value: "75")
                        presetButton("100 (Max)", value: "100")
                    }

                    // Error Banner
                    if let errorMessage = errorMessage {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption)
                            Text(errorMessage)
                                .font(.caption)
                                .fontWeight(.medium)
                            Spacer()
                        }
                        .foregroundStyle(AppTheme.brandCoral)
                        .padding(.horizontal, 4)
                    }

                    // Add Student Button
                    Button(action: addStudent) {
                        HStack(spacing: 8) {
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .font(.headline)
                            Text("Add Student")
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.vertical, 13)
                        .background(AppTheme.primaryGradient)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: AppTheme.brandIndigo.opacity(0.35), radius: 8, x: 0, y: 4)
                    }
                    .padding(.top, 4)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .modernCard(cornerRadius: 18)
    }

    private func presetButton(_ label: String, value: String) -> some View {
        Button(action: { markText = value }) {
            Text(label)
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.primary.opacity(0.06))
                .foregroundStyle(.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var filterControls: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField("Search student...", text: $searchText)
                    .autocorrectionDisabled()
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                    }
                }
            }
            .padding(10)
            .modernCard(cornerRadius: 12)

            Picker("Filter", selection: $selectedFilter) {
                ForEach(RecordFilter.allCases) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var studentsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Students (\(filteredStudents.count))")
                    .font(.headline)
                Spacer()
                if !students.isEmpty {
                    Text("Swipe to delete")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            if filteredStudents.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.badge.questionmark")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                        .padding(.top, 16)
                    Text("No Students Found")
                        .font(.headline)
                    Text(searchText.isEmpty ? "Enter a student name and mark above." : "No records match '\(searchText)'.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 16)
                }
                .frame(maxWidth: .infinity)
                .modernCard(cornerRadius: 16)
            } else {
                VStack(spacing: 10) {
                    ForEach(filteredStudents) { student in
                        NavigationLink(destination: StudentDetailView(student: student)) {
                            studentRow(student)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func studentRow(_ student: Student) -> some View {
        HStack(spacing: 14) {
            // Student Initials
            ZStack {
                Circle()
                    .fill(student.accentGradient.opacity(0.18))
                    .frame(width: 44, height: 44)

                Text(student.initials)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(student.accentColor)
            }

            // Student Name
            VStack(alignment: .leading, spacing: 4) {
                Text(student.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                HStack(spacing: 6) {
                    Text(student.passed ? "Pass" : "Fail")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(student.passed ? AppTheme.brandEmerald.opacity(0.15) : AppTheme.brandCoral.opacity(0.15))
                        .foregroundStyle(student.passed ? AppTheme.brandEmerald : AppTheme.brandCoral)
                        .clipShape(Capsule())

                    Text("Grade \(student.grade)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            // Student Mark
            HStack(spacing: 6) {
                Text("\(student.mark)")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(student.passed ? AppTheme.brandEmerald : AppTheme.brandCoral)

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(14)
        .modernCard(cornerRadius: 14)
        .contextMenu {
            Button(role: .destructive, action: {
                if let index = students.firstIndex(where: { $0.id == student.id }) {
                    withAnimation { students.remove(at: index) }
                }
            }) {
                Label("Delete Student", systemImage: "trash")
            }
        }
    }

    // MARK: - Required Addition Logic (Part D)
    private func addStudent() {
        let trimmedName = studentName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            withAnimation { errorMessage = "Student name cannot be empty." }
            return
        }

        guard let mark = Int(markText.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            withAnimation { errorMessage = "Please enter a valid numeric mark." }
            return
        }

        guard mark >= 0 && mark <= 100 else {
            withAnimation { errorMessage = "Mark must be between 0 and 100." }
            return
        }

        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            errorMessage = nil
            let student = Student(name: trimmedName, mark: mark)
            students.append(student)
            studentName = ""
            markText = ""
        }
    }
}

#Preview {
    ContentView()
}
