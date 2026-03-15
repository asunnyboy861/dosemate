import SwiftUI

struct MedicationCard: View {
    let medication: Medication
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: AppTheme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(medication.isActive ? AppTheme.Colors.primaryBlue.opacity(0.1) : Color.gray.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "syringe.fill")
                        .font(.title2)
                        .foregroundColor(medication.isActive ? AppTheme.Colors.primaryBlue : .gray)
                }
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text(medication.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: AppTheme.Spacing.sm) {
                        Text("\(String(format: "%.1f", medication.dosage)) \(medication.dosageUnit)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text(medication.injectionSite)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                    if medication.isActive {
                        Text("Active")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.Colors.successGreen)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppTheme.Colors.successGreen.opacity(0.1))
                            .cornerRadius(4)
                    } else {
                        Text("Inactive")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Text("\(medication.frequency)x/week")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

struct DashboardCard: View {
    let title: String
    let value: String
    let subtitle: String?
    let icon: String
    let iconColor: Color
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { onTap?() }) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(iconColor.opacity(0.1))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(iconColor)
                    }
                    
                    Spacer()
                    
                    if onTap != nil {
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 20) {
        MedicationCard(medication: Medication(name: "Mounjaro", dosage: 2.5, frequency: 1))
        
        HStack {
            DashboardCard(
                title: "Next Injection",
                value: "Tomorrow",
                subtitle: "Mounjaro 2.5mg",
                icon: "syringe.fill",
                iconColor: AppTheme.Colors.primaryBlue
            )
        }
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
