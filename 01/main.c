#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <stdbool.h>

struct node
{
    uint64_t value;
    struct node *next;
};

void delete(struct node *root)
{
    struct node *node;
    while (root != NULL) {
        node = root;
        root = root->next;
        free(node);
    }
}

void insert(struct node **root, uint64_t value)
{
    struct node *node = malloc(sizeof(struct node));
    node->value = value;
    node->next = NULL;

    if (*root == NULL || (*root)->value > node->value) {
        node->next = *root;
        *root = node;

        return;
    }

    struct node *position = *root;
    while (position->next && position->next->value < node->value) {
        position = position->next;
    }

    node->next = position->next;
    position->next = node;
}

int main(int argc, char** argv)
{
    struct node *lRoot = NULL;
    struct node *rRoot = NULL;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input-file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");

    uint64_t left;
    uint64_t right;
    uint64_t count = 0;
    while (fscanf(file, "%lu   %lu", &left, &right) == 2) {
        insert(&lRoot, left);
        insert(&rRoot, right);
        count++;
    }

    uint64_t distance = 0;
    struct node *lNode = lRoot;
    struct node *rNode = rRoot;

    for (uint64_t i = 0; i < count; ++i) {
        if (rNode->value > lNode->value) {
            distance += rNode->value - lNode->value;
        }
        else {
            distance += lNode->value - rNode->value;
        }
        rNode = rNode->next;
        lNode = lNode->next;
    }

    printf("%lu\n", distance);

    /* PART 2 */
    lNode = lRoot;
    rNode = rRoot;

    uint64_t similarity = 0;
    uint8_t lLastCount = 0;
    uint8_t rLastCount = 0;
    uint64_t value = 0;
    while (lNode != NULL && rNode != NULL) {
        value = lNode->value;
        while (lNode != NULL && lNode->value == value) {
            lLastCount++;
            lNode = lNode->next;
        }

        while (rNode != NULL && rNode->value < value) {
            rNode = rNode->next;
        }

        while (rNode != NULL && rNode->value == value) {
            rLastCount++;
            rNode = rNode->next;
        }

        similarity += value * lLastCount * rLastCount;
        lLastCount = 0;
        rLastCount = 0;
    }

    printf("%lu\n", similarity);


    fclose(file);
    delete(lRoot);
    delete(rRoot);

    return 0;
}

