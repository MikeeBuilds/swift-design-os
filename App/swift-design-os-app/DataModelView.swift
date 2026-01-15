import SwiftUI

struct DataModelView: View {
    @State private var entities: [DataEntity] = [
        DataEntity(name: "User", fields: [
            DataField(name: "id", type: .string),
            DataField(name: "name", type: .string),
            DataField(name: "email", type: .string)
        ]),
        DataEntity(name: "Product", fields: [
            DataField(name: "id", type: .string),
            DataField(name: "title", type: .string),
            DataField(name: "price", type: .number)
        ])
    ]
    @State private var selectedEntity: DataEntity?
    @State private var showAddEntity = false
    
    var body: some View {
        HSplitView {
            entityList
            
            if let selectedEntity = selectedEntity {
                entityDetail(selectedEntity)
            } else {
                entityPlaceholder
            }
        }
        .navigationTitle("Data Model")
        .sheet(isPresented: $showAddEntity) {
            AddEntityView { name in
                entities.append(DataEntity(name: name, fields: []))
                selectedEntity = entities.last
            }
        }
    }
    
    var entityList: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Entities")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top)
                Spacer()
                Button(action: { showAddEntity = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            List(entities, id: \.id, selection: $selectedEntity) { entity in
                HStack {
                    Image(systemName: "cube.box")
                        .foregroundColor(.blue)
                    Text(entity.name)
                        .font(.subheadline)
                    Spacer()
                    Text("\(entity.fields.count) fields")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .frame(minWidth: 200)
    }
    
    func entityDetail(_ entity: DataEntity) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                entityHeader(entity)
                
                fieldsSection(entity)
                
                Spacer()
            }
            .padding()
        }
        .frame(minWidth: 400)
    }
    
    func entityHeader(_ entity: DataEntity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "cube.box.fill")
                    .foregroundColor(.blue)
                Text(entity.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: { 
                    if let index = entities.firstIndex(where: { $0.id == entity.id }) {
                        entities.remove(at: index)
                        selectedEntity = nil
                    }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            Text("Define the data structure for this entity")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    func fieldsSection(_ entity: DataEntity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Fields")
                    .font(.headline)
                Spacer()
                Button(action: {
                    if let index = entities.firstIndex(where: { $0.id == entity.id }) {
                        entities[index].fields.append(DataField(name: "new_field", type: .string))
                    }
                }) {
                    Label("Add Field", systemImage: "plus")
                        .font(.caption)
                }
            }
            
            VStack(spacing: 8) {
                ForEach(entity.fields, id: \.id) { field in
                    fieldRow(field, entity: entity)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    func fieldRow(_ field: DataField, entity: DataEntity) -> some View {
        HStack {
            Image(systemName: field.type.icon)
                .foregroundColor(.secondary)
                .frame(width: 20)
            
            TextField("Field name", text: Binding(
                get: { field.name },
                set: { newValue in
                    if let index = entities.firstIndex(where: { $0.id == entity.id }),
                       let fieldIndex = entities[index].fields.firstIndex(where: { $0.id == field.id }) {
                        entities[index].fields[fieldIndex].name = newValue
                    }
                }
            ))
            .textFieldStyle(.roundedBorder)
            
            Picker("", selection: Binding(
                get: { field.type },
                set: { newValue in
                    if let index = entities.firstIndex(where: { $0.id == entity.id }),
                       let fieldIndex = entities[index].fields.firstIndex(where: { $0.id == field.id }) {
                        entities[index].fields[fieldIndex].type = newValue
                    }
                }
            )) {
                ForEach(FieldType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 100)
            
            Button(action: {
                if let index = entities.firstIndex(where: { $0.id == entity.id }),
                   let fieldIndex = entities[index].fields.firstIndex(where: { $0.id == field.id }) {
                    entities[index].fields.remove(at: fieldIndex)
                }
            }) {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    var entityPlaceholder: some View {
        VStack(spacing: 16) {
            Image(systemName: "cube.box")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.3))
            Text("Select an entity to view details")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 400)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DataEntity: Identifiable {
    let id = UUID()
    var name: String
    var fields: [DataField]
}

struct DataField: Identifiable {
    let id = UUID()
    var name: String
    var type: FieldType
}

enum FieldType: String, CaseIterable {
    case string = "String"
    case number = "Number"
    case boolean = "Boolean"
    case date = "Date"
    case array = "Array"
    case object = "Object"
    
    var icon: String {
        switch self {
        case .string: return "text.alignleft"
        case .number: return "number"
        case .boolean: return "togglepower"
        case .date: return "calendar"
        case .array: return "list.bullet"
        case .object: return "cube.box"
        }
    }
}

struct AddEntityView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    let onSave: (String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Entity Name", text: $name)
            }
            .navigationTitle("Add Entity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onSave(name)
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        DataModelView()
    }
}
