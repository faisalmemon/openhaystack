//
//  OpenHaystack – Tracking personal Bluetooth devices via Apple's Find My network
//
//  Copyright © 2021 Secure Mobile Networking Lab (SEEMOO)
//  Copyright © 2021 The Open Wireless Link Project
//
//  SPDX-License-Identifier: AGPL-3.0-only
//

import SwiftUI

struct ManageAccessoriesView: View {

    @EnvironmentObject var accessoryController: AccessoryController
    var accessories: [Accessory] {
        return self.accessoryController.accessories
    }

    // MARK: Bindings from main View
    @Binding var alertType: OpenHaystackMainView.AlertType?
    @Binding var focusedAccessory: Accessory?
    @Binding var accessoryToDeploy: Accessory?
    @Binding var showESP32DeploySheet: Bool

    var body: some View {
        VStack {
            Text("Your accessories")
                .font(.title2)
                .padding(.top)

            if self.accessories.isEmpty {
                Spacer()
                Text("No accessories have been added yet. Go ahead and add one via the '+' icon.")
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                self.accessoryList
            }
        }
        .toolbar(content: {
            Spacer()
            Button(action: self.addAccessory) {
                Label("Add accessory", systemImage: "plus")
            }
        })
        .sheet(
            isPresented: self.$showESP32DeploySheet,
            content: {
                ESP32InstallSheet(accessory: self.$accessoryToDeploy, alertType: self.$alertType)
            })
    }

    /// Accessory List view.
    var accessoryList: some View {
        List(self.accessories, id: \.self, selection: $focusedAccessory) { accessory in
            AccessoryListEntry(
                accessory: accessory,
                accessoryIcon: Binding(
                    get: { accessory.icon },
                    set: { accessory.icon = $0 }
                ),
                accessoryColor: Binding(
                    get: { accessory.color },
                    set: { accessory.color = $0 }
                ),
                accessoryName: Binding(
                    get: { accessory.name },
                    set: { accessory.name = $0 }
                ),
                alertType: self.$alertType,
                delete: self.delete(accessory:),
                deployAccessoryToMicrobit: self.deploy(accessory:),
                zoomOn: { self.focusedAccessory = $0 })
        }
        .listStyle(SidebarListStyle())

    }

    /// Delete an accessory from the list of accessories.
    func delete(accessory: Accessory) {
        do {
            try self.accessoryController.delete(accessory: accessory)
        } catch {
            self.alertType = .deletionFailed
        }
    }

    func deploy(accessory: Accessory) {
        self.accessoryToDeploy = accessory
        self.alertType = .selectDepoyTarget
    }

    /// Add an accessory with the provided details.
    func addAccessory() {
        do {
            _ = try self.accessoryController.addAccessory()
        } catch {
            self.alertType = .keyError
        }
    }

}

struct ManageAccessoriesView_Previews: PreviewProvider {

    @State static var accessories = PreviewData.accessories
    @State static var alertType: OpenHaystackMainView.AlertType?
    @State static var focussed: Accessory?
    @State static var deploy: Accessory?
    @State static var showESPSheet: Bool = true

    static var previews: some View {
        ManageAccessoriesView(alertType: self.$alertType, focusedAccessory: self.$focussed, accessoryToDeploy: self.$deploy, showESP32DeploySheet: self.$showESPSheet)
    }
}
