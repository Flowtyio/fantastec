import "FungibleToken"
import "FlowStorageFees"

pub contract FlowTokenManager {
  pub fun TopUpFlowTokens(account: PublicAccount, flowTokenProvider: &{FungibleToken.Provider}) {
    if (account.storageUsed > account.storageCapacity) {
      var extraStorageRequiredBytes = account.storageUsed - account.storageCapacity

      var extraStorageRequiredMb = FlowStorageFees.convertUInt64StorageBytesToUFix64Megabytes(extraStorageRequiredBytes)
      var flowRequired = FlowStorageFees.storageCapacityToFlow(extraStorageRequiredMb)

      let vault: @FungibleToken.Vault <- flowTokenProvider.withdraw(amount: flowRequired)
      account
        .getCapability(/public/flowTokenReceiver)!
        .borrow<&{FungibleToken.Receiver}>()!
        .deposit(from: <- vault)
    }
  }
}