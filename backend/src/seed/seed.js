require("dotenv").config();

const mongoose = require("mongoose");

const connectDatabase = require("../config/database");

const Category = require("../models/Category");
const LearningPath = require("../models/LearningPath");
const Minute = require("../models/Minute");

const seed = async () => {
  try {
    await connectDatabase();

    await Minute.deleteMany({});
    await LearningPath.deleteMany({});
    await Category.deleteMany({});

    const categories = await Category.insertMany([
      { name: "Programming", slug: "programming", description: "Build real programming skills.", icon: "code" },
      { name: "Artificial Intelligence", slug: "ai", description: "Understand AI from the ground up.", icon: "brain" },
      { name: "English", slug: "english", description: "Improve practical English skills.", icon: "language" },
      { name: "German", slug: "german", description: "Build your German step by step.", icon: "translate" },
      { name: "General Knowledge", slug: "general-knowledge", description: "Learn something useful every day.", icon: "globe" }
    ]);

    const categoryMap = Object.fromEntries(
      categories.map((category) => [category.slug, category._id])
    );

    const programmingPath = await LearningPath.create({
      title: "JavaScript Fundamentals", slug: "javascript-fundamentals",
      description: "Learn the core concepts of JavaScript.",
      category: categoryMap.programming, level: "beginner", estimatedMinutes: 3, isPublished: true
    });

    const aiPath = await LearningPath.create({
      title: "AI Fundamentals", slug: "ai-fundamentals",
      description: "Understand the foundations of artificial intelligence.",
      category: categoryMap.ai, level: "beginner", estimatedMinutes: 3, isPublished: true
    });

    const englishPath = await LearningPath.create({
      title: "Everyday English", slug: "everyday-english",
      description: "Useful English for everyday communication.",
      category: categoryMap.english, level: "beginner", estimatedMinutes: 3, isPublished: true
    });

    const germanPath = await LearningPath.create({
      title: "German A1", slug: "german-a1",
      description: "Start building your German foundations.",
      category: categoryMap.german, level: "beginner", estimatedMinutes: 3, isPublished: true
    });

    await Minute.insertMany([
      { title: "What is a Variable?", slug: "what-is-a-variable", category: categoryMap.programming, learningPath: programmingPath._id, level: "beginner", order: 1,
        content: "A variable is a named place used to store a value. In JavaScript, variables can be created using let, const, or var.",
        keyTakeaway: "Variables allow your program to store and work with data.",
        question: { question: "Which keyword creates a variable that can be reassigned?", options: ["const", "let", "static", "fixed"], correctAnswer: 1, explanation: "let creates a variable whose value can be changed later." },
        xpReward: 10, isPublished: true },

      { title: "Functions in JavaScript", slug: "functions-in-javascript", category: categoryMap.programming, learningPath: programmingPath._id, level: "beginner", order: 2,
        content: "A function is a reusable block of code that performs a task. You define one using the function keyword or arrow syntax.",
        keyTakeaway: "Functions let you organize and reuse code.",
        question: { question: "Which syntax defines an arrow function?", options: ["function() {}", "() => {}", "def() {}", "func() {}"], correctAnswer: 1, explanation: "Arrow functions use the () => {} syntax." },
        xpReward: 10, isPublished: true },

      { title: "Arrays Basics", slug: "arrays-basics", category: categoryMap.programming, learningPath: programmingPath._id, level: "beginner", order: 3,
        content: "An array is an ordered list of values. You can access items using an index starting from 0.",
        keyTakeaway: "Arrays store multiple values in a single variable.",
        question: { question: "What is the index of the first item in an array?", options: ["1", "0", "-1", "First"], correctAnswer: 1, explanation: "Array indexing starts at 0." },
        xpReward: 10, isPublished: true },

      { title: "What is Artificial Intelligence?", slug: "what-is-artificial-intelligence", category: categoryMap.ai, learningPath: aiPath._id, level: "beginner", order: 1,
        content: "Artificial Intelligence is the field of building systems that can perform tasks that normally require human-like intelligence.",
        keyTakeaway: "AI enables computers to perform tasks involving patterns, decisions, and learning.",
        question: { question: "Which best describes AI?", options: ["A computer brand", "A field of building intelligent systems", "A programming language", "A database"], correctAnswer: 1, explanation: "AI is a field focused on creating systems capable of intelligent behavior." },
        xpReward: 10, isPublished: true },

      { title: "Machine Learning Basics", slug: "machine-learning-basics", category: categoryMap.ai, learningPath: aiPath._id, level: "beginner", order: 2,
        content: "Machine learning is a subset of AI where systems learn patterns from data instead of being explicitly programmed.",
        keyTakeaway: "ML systems improve by learning from data.",
        question: { question: "Machine learning systems mainly learn from what?", options: ["Data", "Manual rules only", "Random guesses", "Hardware"], correctAnswer: 0, explanation: "Machine learning relies on learning patterns from data." },
        xpReward: 10, isPublished: true },

      { title: "Neural Networks Intro", slug: "neural-networks-intro", category: categoryMap.ai, learningPath: aiPath._id, level: "beginner", order: 3,
        content: "A neural network is a system of connected nodes inspired by the human brain, used to recognize patterns.",
        keyTakeaway: "Neural networks are inspired by how the brain processes information.",
        question: { question: "Neural networks are inspired by what?", options: ["The human brain", "Car engines", "Databases", "Keyboards"], correctAnswer: 0, explanation: "Neural networks are inspired by biological neurons in the brain." },
        xpReward: 10, isPublished: true },

      { title: "Introducing Yourself", slug: "english-introducing-yourself", category: categoryMap.english, learningPath: englishPath._id, level: "beginner", order: 1,
        content: "A simple introduction can start with: Hello, my name is Abdelaziz. Nice to meet you.",
        keyTakeaway: "Simple introductions are one of the most useful English communication skills.",
        question: { question: "Which sentence is a natural introduction?", options: ["My name are Ali.", "My name is Ali.", "I name Ali.", "Name my Ali."], correctAnswer: 1, explanation: "My name is Ali is the standard English structure." },
        xpReward: 10, isPublished: true },

      { title: "Asking for Directions", slug: "asking-for-directions", category: categoryMap.english, learningPath: englishPath._id, level: "beginner", order: 2,
        content: "A common way to ask for directions is: Excuse me, how do I get to the train station?",
        keyTakeaway: "Polite phrasing helps when asking strangers for help.",
        question: { question: "Which phrase politely asks for directions?", options: ["Where station now?", "Excuse me, how do I get to the station?", "Station where go?", "Give me station."], correctAnswer: 1, explanation: "Excuse me, how do I get to... is the polite standard form." },
        xpReward: 10, isPublished: true },

      { title: "Ordering Food", slug: "ordering-food", category: categoryMap.english, learningPath: englishPath._id, level: "beginner", order: 3,
        content: "At a restaurant you can say: Could I have the menu, please? or I would like to order a coffee.",
        keyTakeaway: "Polite requests are common in everyday English.",
        question: { question: "Which is a polite way to order?", options: ["Give coffee now.", "I would like to order a coffee, please.", "Coffee me.", "Want coffee."], correctAnswer: 1, explanation: "I would like to order... please is the polite standard form." },
        xpReward: 10, isPublished: true },

      { title: "German Greetings", slug: "german-greetings", category: categoryMap.german, learningPath: germanPath._id, level: "beginner", order: 1,
        content: "Hallo means hello. Guten Morgen means good morning. Guten Abend means good evening.",
        keyTakeaway: "German has different greetings depending on the time and situation.",
        question: { question: "What does Guten Morgen mean?", options: ["Good night", "Good evening", "Good morning", "Goodbye"], correctAnswer: 2, explanation: "Guten Morgen means Good morning." },
        xpReward: 10, isPublished: true },

      { title: "Numbers 1-10", slug: "german-numbers-1-10", category: categoryMap.german, learningPath: germanPath._id, level: "beginner", order: 2,
        content: "Eins, zwei, drei, vier, fünf, sechs, sieben, acht, neun, zehn are the numbers one to ten in German.",
        keyTakeaway: "Learning basic numbers is essential for everyday German.",
        question: { question: "What is 'drei' in English?", options: ["Two", "Three", "Four", "Five"], correctAnswer: 1, explanation: "Drei means three in German." },
        xpReward: 10, isPublished: true },

      { title: "Basic Phrases", slug: "german-basic-phrases", category: categoryMap.german, learningPath: germanPath._id, level: "beginner", order: 3,
        content: "Danke means thank you. Bitte means please or you're welcome. Tschüss means bye.",
        keyTakeaway: "These basic phrases cover common daily interactions.",
        question: { question: "What does 'Danke' mean?", options: ["Please", "Thank you", "Goodbye", "Hello"], correctAnswer: 1, explanation: "Danke means thank you in German." },
        xpReward: 10, isPublished: true }
    ]);

    console.log("Database seeded successfully");

    await mongoose.connection.close();
    process.exit(0);
  } catch (error) {
    console.error("Seed failed:", error);
    await mongoose.connection.close();
    process.exit(1);
  }
};

seed();