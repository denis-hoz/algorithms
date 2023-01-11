//
// 68. Text Justification
// Hard
// https://leetcode.com/problems/text-justification/
//
//
// Given an array of strings words and a width maxWidth,
// format the text such that each line has exactly maxWidth
// characters and is fully (left and right) justified.
//
// You should pack your words in a greedy approach; that is,
// pack as many words as you can in each line. Pad extra spaces ' '
// when necessary so that each line has exactly maxWidth characters.
//
// Extra spaces between words should be distributed as evenly as
// possible. If the number of spaces on a line does not divide evenly
// between words, the empty slots on the left will be assigned more
// spaces than the slots on the right.
//
// For the last line of text, it should be left-justified, and no
// extra space is inserted between words.
//
//
// Note:
//
// * A word is defined as a character sequence consisting
//   of non-space characters only.
// * Each word's length is guaranteed to be greater than 0
//   and not exceed maxWidth.
// * The input array words contains at least one word.
//

import Foundation

class Solution {
    var currentLineWidth = 0

    func fullJustify(_ words: [String], _ maxWidth: Int) -> [String] {
        let lines = split(words, maxWidth)

        /// Align left last line
        guard let lastLineResult = lines.last?.alignedLeft(width: maxWidth) else {
            return []
        }

        /// Justify all lines except last
        let result: [String] = lines.dropLast().map { words in
            words.fullJustified(width: maxWidth)
        }

        return result + [lastLineResult]
    }
}

private extension Solution {
    func split(_ words: [String], _ maxWidth: Int) -> [[String]] {
        words.reduce(into: [[]]) { result, word in
            appendLineIfNeeded(nextWord: word, result: &result, maxWidth: maxWidth)
            appendWord(word, to: &result)
        }
    }

    func appendLineIfNeeded(nextWord: String, result: inout [[String]], maxWidth: Int) {
        if currentLineWidth + nextWord.count > maxWidth {
            appendNewLine(to: &result)
        }
    }

    func appendWord(_ word: String, to result: inout [[String]]) {
        result[result.count - 1].append(word)
        currentLineWidth += word.count + 1 /// + 1 for whitespace
    }

    func appendNewLine(to result: inout [[String]]) {
        result.append([])
        currentLineWidth = 0
    }
}

extension String {
    func appendingSpaces(count: Int) -> String {
        appending(
            String(repeating: " ", count: count)
        )
    }

    func addingTrimmingSpaces(width: Int) -> String {
        appendingSpaces(count: width - count)
    }
}

extension Array where Element == String {
    private var wordsWidth: Int {
        map(\.count).reduce(0, +)
    }

    func fullJustified(width: Int) -> String {
        justified(width: width) ?? alignedLeft(width: width)
    }

    func alignedLeft(width: Int) -> String {
        joined(separator: " ").addingTrimmingSpaces(width: width)
    }

    func justified(width: Int) -> String? {
        guard count > 1 else {
            return nil
        }

        let separatorsCount = count - 1
        let spaceCharactersWidth = width - wordsWidth
        let spacesWidth = spaceCharactersWidth / separatorsCount

        /// word1...word2...word3..word4..word5
        /// 3 spaces for first 2 separator
        /// 2 spaces for next 2 separators
        let bigSpacesCount = spaceCharactersWidth % separatorsCount

        /// "word1   word2   word3..word4..word5"
        let smallSeparator = String(repeating: " ", count: spacesWidth)

        /// "word1...word2...word3  word4  word5"
        let bigSeparator = String(repeating: " ", count: spacesWidth + 1)

        /// "[word1, word2]
        let prefix = prefix(bigSpacesCount)

        /// "word3..word4..word5"
        let suffix = suffix(from: bigSpacesCount)
            .joined(separator: smallSeparator)

        /// "word1...word2...[suffix]"
        return (prefix + [suffix])
            .joined(separator: bigSeparator)

    }
}

let tests = [
    ["This", "is", "an", "example", "of", "text", "justification."],
    ["This", "is"],
    ["This"],
    ["What","must","be","acknowledgment","shall","be"],
    ["Science","is","what","we","understand","well","enough","to","explain","to","a","computer.","Art","is","everything","else","we","do"],
    ["Listen","to","many,","speak","to","a","few."]
]

for test in tests {
    for i in 14..<50 {
        testSolution(test, i)
    }
}

testSolution(["Listen","to","many,","speak","to","a","few."], 7)
testSolution(["Listen","to","many,","speak","to","a","few."], 6)

func testSolution(_ test: [String], _ i: Int) {
    let solution = Solution().fullJustify(test, i)

    solution.forEach { line in
        print("`\(line)`")

        guard line.count == i else {
            fatalError("Unexpected `\(line)` length(\(line.count)) != \(i)")
        }
    }

    print("")
    print("")
}
