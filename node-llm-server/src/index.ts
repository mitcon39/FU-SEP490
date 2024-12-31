import { fileURLToPath } from "url";
import path from "path";
import chalk from "chalk";
import { getLlama, LlamaChatSession, resolveModelFile } from "node-llama-cpp";
import express from "express";

const app = express();
app.use(express.json());

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const modelsDirectory = path.join(__dirname, "..", "models");

const llama = await getLlama();
const modelName =
    "hf:mradermacher/Llama-3.2-3B-Instruct-GGUF/Llama-3.2-3B-Instruct.Q8_0.gguf";
console.log(chalk.yellow("Resolving model file..."));
const modelPath = await resolveModelFile(modelName, modelsDirectory);

console.log(chalk.yellow("Loading model..."));
const model = await llama.loadModel({ modelPath });

console.log(chalk.yellow("Creating context..."));
const context = await model.createContext();

const session = new LlamaChatSession({
    contextSequence: context.getSequence(),
    systemPrompt:
        "Bạn là một trợ lý AI. Hãy trả lời tất cả các câu hỏi bằng tiếng Việt.",
});

const PORT = process.env.PORT || 6969;
app.listen(PORT, () => {
    console.log(chalk.yellow(`Server started on port ${PORT}`));
});

app.post("/chat", async (req, res) => {
    const { message } = req.body;
    console.log(chalk.green(`User: ${message}`));
    const response = await session.prompt(message);
    console.log(chalk.green(`Llama: ${response}`));
    res.send({ response });
});
