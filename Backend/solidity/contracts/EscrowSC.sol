// Import the necessary libraries
const { Client, AccountCreateTransaction, Hbar, TransferTransaction } = require("@hashgraph/sdk");

// Set up the Hedera client
const client = Client.forTestnet();
client.setOperator(process.env.ACCOUNT_ID, process.env.PRIVATE_KEY);

// Define the smart contract
class FreelanceEscrowContract {
    constructor(client, clientAccount, freelancerAccount) {
        this.client = client;
        this.clientAccount = clientAccount;
        this.freelancerAccount = freelancerAccount;
        this.escrowAmount = Hbar.fromTinybars(100); // Example escrow amount
        this.jobConfirmed = false;
    }

    async createEscrow() {
        // Transfer funds to escrow
        const transferTransaction = new TransferTransaction()
            .addHbarTransfer(this.clientAccount, this.escrowAmount.negated())
            .addHbarTransfer(this.freelancerAccount, this.escrowAmount)
            .execute(this.client);

        // Confirm the job
        this.jobConfirmed = true;

        // Execute the transaction
        await transferTransaction.execute(this.client);

        // Print confirmation message
        console.log("Escrow created successfully. Payment held until job confirmation.");
    }

    async confirmJob() {
        if (this.jobConfirmed) {
            // Release funds from escrow
            const transferTransaction = new TransferTransaction()
                .addHbarTransfer(this.freelancerAccount, this.escrowAmount.negated())
                .addHbarTransfer(this.clientAccount, this.escrowAmount)
                .execute(this.client);

            // Execute the transaction
            await transferTransaction.execute(this.client);

            // Print confirmation message
            console.log("Job confirmed. Payment released from escrow to freelancer.");
        } else {
            console.log("Job not confirmed yet.");
        }
    }
}

// Example usage
const clientAccount = process.env.CLIENT_ACCOUNT_ID;
const freelancerAccount = process.env.FREELANCER_ACCOUNT_ID;

const escrowContract = new FreelanceEscrowContract(client, clientAccount, freelancerAccount);

// Client creates the escrow
escrowContract.createEscrow();

// Freelancer confirms the job
escrowContract.confirmJob();
