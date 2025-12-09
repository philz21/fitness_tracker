import { test, expect } from '@playwright/test';

test.describe('Exercise library', () => {
  test('search and use an exercise', async ({ page }) => {
    await page.goto('/exercises');

    // Search for an exercise
    await page.getByPlaceholder('Search exercise name').fill('bench');
    await page.getByRole('button', { name: 'Search' }).click();

    // Wait for at least one card to appear
    const firstCard = page.locator('.card').first();
    await expect(firstCard).toBeVisible();

    // Click "Use this exercise"
    await firstCard.getByRole('link', { name: 'Use this exercise' }).click();

    // We’re on the root path with an exercise query
    await expect(page).toHaveURL(/\/\?exercise=/);
    await expect(page.getByLabel('Exercise')).toHaveValue(/bench/i);
    });
  
  test('shows a prompt when search is submitted empty', async ({ page }) => {
    await page.goto('/exercises');
    await page.getByRole('button', { name: 'Search' }).click();
    await expect(page.getByText('Please enter a search term (e.g. bench, squat, row).')).toBeVisible();

    //ensure we didn’t show any result cards
    await expect(page.locator('.card')).toHaveCount(0);
    });

});
